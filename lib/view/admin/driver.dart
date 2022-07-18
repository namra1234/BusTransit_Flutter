import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_bus_transit/model/schoolModel.dart';
import 'package:school_bus_transit/repository/driverRep.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:avatar_glow/avatar_glow.dart';

import '../../common/colorConstants.dart';
import '../../common/constants.dart';
import '../../model/busModel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../model/userModel.dart';
import '../../repository/busRep.dart';
import 'package:url_launcher/url_launcher.dart';

class Driver extends StatefulWidget {
  SchoolModel school_;
  BusModel bus_;

  Driver({Key? key, required this.school_, required this.bus_})
      : super(key: key);

  @override
  _DriverState createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  bool loading = true;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    getDriverInfo(widget.bus_.bus_id);
    print(widget.school_.name + "  --- > Driver class");
    print(widget.bus_.bus_number.toString() + " --->  Driver");
  }

  @override
  void dispose() {
    super.dispose();
  }

  getDriverInfo(String bus_id) async {
    print("calling driverSection -> getDriverList()");
    await DriverRepository().getBusDriver(bus_id);
    setState(() {
      loading = false;
    });
  }

  releaseDriver(String driver_id) async {
    print("calling driverSection -> deleteBus()");
    await DriverRepository()
        .updateDriverSpecificDetails("bus_id", "", driver_id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Driver - Bus Info",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: ColorConstants.whiteColor,
      body: SafeArea(
        child: loading
            ? CircularProgressIndicator(
          color: ColorConstants.TripOnColor,
        )
            : SingleChildScrollView(
              child: Container(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: <Widget>[
                      titleSection(),
                      SchoolDetailSection(),
                      DriverInfoSection(),
                    ],
                  ),
                ),
            ),
      ),
    );
  }

  Widget titleSection() {
    String busNumber = widget.bus_.bus_number.toString();
    return Container(
      child: Text("Bus Number : $busNumber",
          style: TextStyle(
            fontSize: 25,
          )),
      // color: ColorConstants.titleGreyColor,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      width: Constants.width,
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: ColorConstants.titleGreyColor,
      ),
    );
  }

  Widget SchoolDetailSection() {
    return ZoomTapAnimation(
      child: Card(
        child: Column(
          children: <Widget>[
            const ListTile(
              title: Text(
                "School name",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(widget.school_.name,
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
            const ListTile(
              title: Text(
                "School Address",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(widget.school_.address,
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
            const ListTile(
              title: Text(
                "Terminal Address",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(widget.bus_.destination,
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
        elevation: 8,
        shadowColor: Colors.black,
        color: ColorConstants.primaryColor,
        margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey, width: 0)),
      ),
    );
  }

  //----------------- driver list widget group -----------------------
  Widget DriverInfoSection() {
    return Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return DetailScreen(
                            img_url: Constants.CurrentDriverdata.photo_url);
                      }));
                    },
                    child: DriverProfileImage(
                        Constants.CurrentDriverdata.photo_url)),
                Text(Constants.CurrentDriverdata.fullName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
          const ListTile(
            title: Text(
              "School name",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(widget.school_.name,
                style: TextStyle(
                  fontSize: 20,
                )),
          ),
          const ListTile(
            title: Text(
              "School Address",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(widget.school_.address,
                style: TextStyle(
                  fontSize: 20,
                )),
          ),
          const ListTile(
            title: Text(
              "Terminal Address",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(widget.bus_.destination,
                style: TextStyle(
                  fontSize: 20,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: releaseDriverButton(Constants.CurrentDriverdata.user_id),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
      elevation: 8,
      shadowColor: Colors.black,
      color: ColorConstants.schoolListColor,
      margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey, width: 0)),
    );
  }

  Widget DriverProfileImage(String ImgUrl) {
    print(ImgUrl);
    return AvatarGlow(
      endRadius: 50.0,
      child: Material(
        // Replace this child with your own
        elevation: 8.0,
        shape: CircleBorder(),
        child: CircleAvatar(
          backgroundColor: Colors.green[100],
          child: Image.network(
            ImgUrl,
            height: 50,
          ),
          radius: 30.0,
        ),
      ),
    );
  }

  //----------------------------------------------------------------

  Widget releaseDriverButton(String driver_id) {
    return Container(
      width: Constants.width * 0.8,
      margin: EdgeInsets.only(top: 10, bottom: 20),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: ColorConstants.DeleteButtonColor,
          primary: Colors.white,
          elevation: 10,
        ),
        child: Text(
          "Release Driver",
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: () {
          releaseDriver(driver_id);
          print("Released Driver");
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  String img_url = "";
  DetailScreen({Key? key, required this.img_url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(img_url),
          ),
        ),
      ),
    );
  }
}

//--------------------- avatar glow -------
// https://pub.dev/packages/avatar_glow
// https://fluttergems.dev/avatar-profile-picture-chat-heads/
// https://pub.dev/packages/multiavatar
// https://multiavatar.com/

//------------ bouncing button link---------
// https://stackoverflow.com/questions/54526193/bounce-button-flutter
