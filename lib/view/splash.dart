import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_bus_transit/view/authentication/signup.dart';
import '../common/buttonStyle.dart';
import '../common/colorConstants.dart';
import '../common/constants.dart';
import '../common/textStyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    moveToNextScreen();
  }

  void moveToNextScreen() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loginStatus = prefs.getBool('isLoggedin');

    if (loginStatus == null) loginStatus = false;

    try{
      if (loginStatus) {
      }
      else
      {
        var _duartion = new Duration(
          seconds: Constants.SPLASH_SCREEN_TIME,
        );
        Timer(_duartion, () async {

          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              SignupScreen()), (Route<dynamic> route) => false);
        });
      }
    }
    catch(e)
    {
      var _duartion = new Duration(
        seconds: Constants.SPLASH_SCREEN_TIME,
      );
      Timer(_duartion, () async {

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            SignupScreen()), (Route<dynamic> route) => false);

      });
    }
  }


  @override
  Widget build(BuildContext context) {

    Constants.height = MediaQuery.of(context).size.height;
    Constants.width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(top:Constants.height/5),
              child: Center(
                child: SizedBox(
                  height: Constants.height/2,
                  child: Container(
                      child: Image.asset('assets/images/app_logo.png')),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom:Constants.height/15),
                child: Container(
                  child: Text('M2nd Transit',style: CustomTextStyle.splashWelcome(36, Constants.height, Constants.width,ColorConstants.blackColor.withOpacity(0.8))),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}