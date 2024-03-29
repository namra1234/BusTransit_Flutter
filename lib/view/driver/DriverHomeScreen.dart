import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:location/location.dart';
import '../../common/buttonStyle.dart';
import 'package:school_bus_transit/common/constants.dart';
import '../../common/textStyle.dart';
import '../../model/busModel.dart';
import '../../repository/busRep.dart';
import './driverNotification.dart';
import '../../common/colorConstants.dart';

class DriverHomePage extends StatefulWidget {
  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage>
    with WidgetsBindingObserver {
  Completer<GoogleMapController> _controller = Completer();
  static late CameraPosition _kGooglePlex;
  static late Marker _sourceMarker;
  static late Marker _destMarker;
  static late Marker _currentMarker;
  bool fromPoly = false;
  late Stream busSnapShot;
  List<LatLng> polylineCoordinates = [];
  late BitmapDescriptor currentLocIcon;
  late Map<dynamic, dynamic> busDetails;
  DateTime? now = null;
  bool sendLocation = false;

  @override
  void initState() {
    setCustomMarkerIcon();
    // busSnapShot = BusRepository().getBus(Constants.userdata.bus_id);
    // if (busDetails.values.length > 0) {
    //   setMap();
    // }

    super.initState();
  }

  void setMap() {
    if (busDetails.values.length > 0) {
      _kGooglePlex = CameraPosition(
        target: LatLng(double.parse(busDetails["current_lat"]),
            double.parse(busDetails["current_long"])),
        zoom: 14.0,
      );

      if(!busDetails["going_to_school"])
      {
        _sourceMarker = Marker(
            markerId: MarkerId("sourceId"),
            infoWindow: InfoWindow(title: "Source " +busDetails["source"]),
            icon: BitmapDescriptor.defaultMarker,
            position: LatLng(double.parse(busDetails["source_lat"]),
                double.parse(busDetails["source_long"])));
        _destMarker = Marker(
            markerId: MarkerId("destId"),
            infoWindow: InfoWindow(title: "Destination - "+busDetails["destination"]),
            icon: BitmapDescriptor.defaultMarker,
            position: LatLng(double.parse(busDetails["destination_lat"]),
                double.parse(busDetails["destination_long"])));
      }
      else
      {
        _destMarker = Marker(
            markerId: MarkerId("sourceId"),
            infoWindow: InfoWindow(title: "Destination - "+busDetails["source"]),
            icon: BitmapDescriptor.defaultMarker,
            position: LatLng(double.parse(busDetails["source_lat"]),
                double.parse(busDetails["source_long"])));
        _sourceMarker= Marker(
            markerId: MarkerId("destId"),
            infoWindow: InfoWindow(title: "Source "+busDetails["destination"]),
            icon: BitmapDescriptor.defaultMarker,
            position: LatLng(double.parse(busDetails["destination_lat"]),
                double.parse(busDetails["destination_long"])));
      }

      _currentMarker = Marker(
          markerId: const MarkerId("currentId"),
          infoWindow: const InfoWindow(title: "Current Location"),
          icon: currentLocIcon,
          position: LatLng(double.parse(busDetails["current_lat"]),
              double.parse(busDetails["current_long"])));
    }
  }

  getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result;
    if(busDetails["going_to_school"])
    {
      result = await polylinePoints.getRouteBetweenCoordinates(
          Constants.API_KEY,
          PointLatLng(double.parse(busDetails["current_lat"]),
              double.parse(busDetails["current_long"])),
          PointLatLng(double.parse(busDetails["source_lat"]),
              double.parse(busDetails["source_long"])));
    }
    else
    {
      result = await polylinePoints.getRouteBetweenCoordinates(
          Constants.API_KEY,
          PointLatLng(double.parse(busDetails["current_lat"]),
              double.parse(busDetails["current_long"])),
          PointLatLng(double.parse(busDetails["destination_lat"]),
              double.parse(busDetails["destination_long"])));
    }

    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      result.points.forEach(
            (PointLatLng point) =>
            polylineCoordinates.add(LatLng(point.latitude, point.longitude)),
      );
    }
    print("Call infinite");

    setState(() {
      fromPoly=true;
    });
  }

  void setCustomMarkerIcon()
  {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(40, 40)),
            "assets/images/second_logo.png")
        .then((icon) => {currentLocIcon = icon});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void sendCurrentToSchoolData() async
  {

    if(sendLocation)
      {
        var location = Location();

        if (!await location.serviceEnabled()) {
          if (!await location.requestService()) {
            return;
          }
        }

        var permission = await location.hasPermission();
        if (permission == PermissionStatus.denied) {
          permission = await location.requestPermission();
          if (permission != PermissionStatus.granted) {
            return;
          }
        }

        Position position = await Geolocator.getCurrentPosition();
        print(position);

        Map<String,dynamic> bus_info = new Map<String,dynamic>();
        bus_info.putIfAbsent("current_lat", () => position.latitude.toString());
        bus_info.putIfAbsent("current_long", () => position.longitude.toString());
        bus_info.putIfAbsent("active_sharing", () => true);
        bus_info.putIfAbsent("going_to_school", () => true);

        await BusRepository().updateBus(
            bus_info,Constants.userdata.bus_id);

        sendCurrentToSchoolData();
      }

  }

  void sendCurrentFromSchoolData() async
  {

    if(sendLocation)
    {
      var location = Location();

      if (!await location.serviceEnabled()) {
        if (!await location.requestService()) {
          return;
        }
      }

      var permission = await location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await location.requestPermission();
        if (permission != PermissionStatus.granted) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      print(position);

      Map<String,dynamic> bus_info = new Map<String,dynamic>();
      bus_info.putIfAbsent("current_lat", () => position.latitude.toString());
      bus_info.putIfAbsent("current_long", () => position.longitude.toString());
      bus_info.putIfAbsent("active_sharing", () => true);
      bus_info.putIfAbsent("going_to_school", () => false);

      await BusRepository().updateBus(
          bus_info,Constants.userdata.bus_id);

      sendCurrentFromSchoolData();
    }

  }

  void startLocationSharingToSchool()
  {
    sendLocation = true;
    sendCurrentToSchoolData();
  }

  void startLocationSharingFromSchool()
  {
    sendLocation = true;
    sendCurrentFromSchoolData();
  }

  void stopLocationSharing() async
  {
    sendLocation = false;
    Map<String,dynamic> bus_info = new Map<String,dynamic>();
    bus_info.putIfAbsent("active_sharing", () => false);

    await BusRepository().updateBus(
        bus_info,Constants.userdata.bus_id);
  }


  @override
  Widget build(BuildContext context) {
    Constants.height = MediaQuery.of(context).size.height;
    Constants.width = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Bus').doc(Constants.userdata.bus_id).snapshots(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          print("hello");
          if (snapshot.hasData) {
            busDetails = snapshot.data.data();

            if(now==null) {
              now = DateTime.now();
              getPolyPoints();
            }


            setMap();

            if(now!.add(new Duration(milliseconds: 2000)).isBefore(DateTime.now()))
            {
              now= DateTime.now();
              getPolyPoints();
            }

            return Scaffold(
                body: SafeArea(
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text("Your are on trip from school",
                        style: TextStyle(fontSize: 20)),
                    Column(
                      children: [
                        Container(
                          height: Constants.height / 2,
                          child: GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: _kGooglePlex,
                            polylines: {
                              Polyline(
                                  polylineId: const PolylineId("route"),
                                  points: polylineCoordinates,
                                  color: Colors.blue,
                                  width: 4)
                            },
                            markers: {
                              _currentMarker,
                              _sourceMarker,
                              _destMarker
                            },
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          ),
                        )
                      ],
                    ),
                    centerButton(
                        Constants.height / 18,
                        Constants.width * 0.40,
                        Constants.width * 0.08,
                        ColorConstants.primaryColor,
                        ColorConstants.blackColor,
                        "Trip From School",
                        startLocationSharingFromSchool,
                        context),
                    SizedBox(height: 20),
                    centerButton(
                        Constants.height / 18,
                        Constants.width * 0.40,
                        Constants.width * 0.08,
                        ColorConstants.primaryColor,
                        ColorConstants.blackColor,
                        "Trip To School",
                        startLocationSharingToSchool,
                        context),
                    SizedBox(height: 20),
                    centerButton(
                        Constants.height / 18,
                        Constants.width * 0.40,
                        Constants.width * 0.08,
                        ColorConstants.primaryColor,
                        ColorConstants.blackColor,
                        "Stop Trip",
                        stopLocationSharing,
                        context),
                    SizedBox(height: 20),
                  ],
                ),
              )),
            ));
          }
          return Scaffold(
              body: SafeArea(
              child: Center()));
        });
  }
}
