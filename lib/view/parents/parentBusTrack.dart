import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../common/buttonStyle.dart';
import '../../common/constants.dart';
import '../../common/colorConstants.dart';

class parentBusTrack extends StatefulWidget {
   String bus_id;

   parentBusTrack({Key? key, required this.bus_id})
       : super(key: key);

  @override
  _parentBusTrackState createState() => _parentBusTrackState();
}

class _parentBusTrackState extends State<parentBusTrack>
    with WidgetsBindingObserver {
  Completer<GoogleMapController> _controller = Completer();
  static late CameraPosition _kGooglePlex;
  static late Marker _sourceMarker;
  static late Marker _destMarker;
  static late Marker _currentMarker;
  late Stream busSnapShot;
  List<LatLng> polylineCoordinates = [];
  late BitmapDescriptor currentLocIcon;
  late Map<dynamic, dynamic> busDetails;
  bool fromPoly = false;
  DateTime? now = null;
  String bus_id = "";

  @override
  void initState() {
    setCustomMarkerIcon();
    super.initState();
    this.bus_id = widget.bus_id;
  }

  void setMap() {
    if (busDetails.values.length > 0) {
      _kGooglePlex = CameraPosition(
        target: LatLng(double.parse(busDetails["current_lat"]),
            double.parse(busDetails["current_long"])),
        zoom: 14.0,
      );

      _sourceMarker = Marker(
          markerId: MarkerId("sourceId"),
          infoWindow: InfoWindow(title: "Source"),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(double.parse(busDetails["source_lat"]),
              double.parse(busDetails["source_long"])));
      _destMarker = Marker(
          markerId: MarkerId("destId"),
          infoWindow: InfoWindow(title: "Destination"),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(double.parse(busDetails["destination_lat"]),
              double.parse(busDetails["destination_long"])));
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
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Constants.API_KEY,
        PointLatLng(double.parse(busDetails["current_lat"]),
            double.parse(busDetails["current_long"])),
        PointLatLng(double.parse(busDetails["destination_lat"]),
            double.parse(busDetails["destination_long"])));
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

  void setCustomMarkerIcon() {
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

  @override
  Widget build(BuildContext context) {
    Constants.height = MediaQuery.of(context).size.height;
    Constants.width = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Bus').doc(bus_id).snapshots(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          print("hello");
          if (snapshot.hasData) {
            busDetails = snapshot.data.data();

            if(now==null) {
              now = DateTime.now();
              getPolyPoints();
            }


            setMap();

            if(now!.add(new Duration(milliseconds: 5000)).millisecond< DateTime.now().microsecond)
            {
              now= DateTime.now();
              getPolyPoints();
            }

            return Scaffold(
                appBar: AppBar(
                  backgroundColor: ColorConstants.primaryColor,
                  title: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text("Welcome John"),
                      )
                    ],
                  ),
                  elevation: 0.0,
                  centerTitle: false,
                ),
                body: SafeArea(
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Track location of you child",
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
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:20),
                          child: Text("Time to get Destination : ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:10),
                          child: Text("35 Minutes",style: TextStyle(fontSize: 12),textAlign: TextAlign.start),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:20),
                          child: Text("Driver Name : ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:10),
                          child: Text("35 Minutes",style: TextStyle(fontSize: 12),textAlign: TextAlign.start),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:30),
                          child: Text("Get Driver Info. ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                        ),
                      ],
                    )
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
