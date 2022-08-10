import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:school_bus_transit/view/driver/DriverHomeScreen.dart';
import 'package:school_bus_transit/view/driver/driverProfile.dart';
import '../../common/buttonStyle.dart';
import '../../common/constants.dart';
import '../../common/textStyle.dart';
import '../../model/busModel.dart';
import '../../repository/busRep.dart';
import './driverNotification.dart';
import './driverProfile.dart';

import '../../common/colorConstants.dart';

class DriverMainPage extends StatefulWidget {
  @override
  _DriverMainPageState createState() => _DriverMainPageState();
}

class _DriverMainPageState extends State<DriverMainPage>
    with WidgetsBindingObserver {
  late int currentIndex;

  late BusModel busdata;
  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  @override
  void initState() {
    getBusInfo();
    currentIndex = 1;
    super.initState();
  }
  getBusInfo() async {
    busdata = await BusRepository().getBusInfo(Constants.userdata.bus_id);
    print("busdata" + busdata.bus_id);
    setState(() {    });
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

  changePage(int? index) {
    setState(() {
      currentIndex = index!;
    });
  }

  @override
  Widget build(BuildContext context) {
    Constants.height = MediaQuery
        .of(context)
        .size
        .height;
    Constants.width = MediaQuery
        .of(context)
        .size
        .width;
    // TODO: implement build

    return Scaffold(
        bottomNavigationBar: BottomBar(),
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
        body: currentIndex == 1
            ? DriverHomePage()
            : currentIndex == 0
            ? DriverNotification()
            : currentIndex == 2
            ? DriverProfile()
            :Column()
    );
  }

  Widget BottomBar() {
    return BubbleBottomBar(
      hasNotch: true,
      opacity: 0.2,
      currentIndex: currentIndex,
      onTap: changePage,
      backgroundColor: ColorConstants.primaryColor,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ), //border radius doesn't work when the notch is enabled.
      elevation: 8,
      tilesPadding: EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      items: <BubbleBottomBarItem>[
        BubbleBottomBarItem(
            backgroundColor: Colors.black,
            icon: Icon(
              Icons.notifications,
              color: ColorConstants.bottomBarIconColor,
            ),
            activeIcon: Icon(
              Icons.notifications,
              color: Colors.black,
            ),
            title: Text("Notifications")),
        BubbleBottomBarItem(
            backgroundColor: Colors.black,
            icon: Icon(
              Icons.home,
              color: ColorConstants.bottomBarIconColor,
            ),
            activeIcon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: Text("Home"),
        ),
        BubbleBottomBarItem(
            backgroundColor: Colors.black,
            icon: Icon(
              Icons.person,
              color: ColorConstants.bottomBarIconColor,
            ),
            activeIcon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            title: Text("Profile"))
      ],
    );
  }
  Widget NoBusScreen(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/second_logo.png"
              , height: 100,width: 100),
          SizedBox(height: 20),
          Text("Admin Have not Assigned Bus To You ",
            style: CustomTextStyle.mediumText(20, Constants.width)
                .apply(fontStyle: FontStyle.italic))
        ],
      )
    );
  }

}
