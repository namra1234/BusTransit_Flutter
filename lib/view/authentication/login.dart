import 'package:flutter/material.dart';
import 'package:school_bus_transit/common/buttonStyle.dart';
import 'package:school_bus_transit/common/colorConstants.dart';
import 'package:school_bus_transit/common/textStyle.dart';
import 'package:school_bus_transit/repository/busRep.dart';
import 'package:school_bus_transit/view/admin/dashBoard.dart';
import 'package:school_bus_transit/view/driver/driverMainScreen.dart';
import 'package:school_bus_transit/view/parents/parentHomeScreen.dart';
import 'package:school_bus_transit/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../repository/userRep.dart';
import '../driver/driverNotification.dart';
import './signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  String name = "";
  bool changeButton = false;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController emailController,
      passwordController;

  void showSnackBar(String message) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ),);

  }


  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    // emailController.text = "milan@gmail.com";
    // passwordController.text = "123456";
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  login() async {
    if(_formKey.currentState!.validate()){
      FocusManager.instance.primaryFocus?.unfocus();


      if(emailController.text=="admin" && passwordController.text=="admin")
        {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  DashBoardScreen()
          ));
        }
      else {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text)
            .then((value) async
        {
          Constants.loggedInUserID = FirebaseAuth.instance.currentUser!.uid;
          await UserRepository().getUser(Constants.loggedInUserID);

          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setBool('isLoggedin', true);

          preferences.setString('user_id', Constants.userdata.user_id);
          preferences.setString(
              'fullName', Constants.userdata.fullName);
          preferences.setString('email_id', Constants.userdata.email_id);
          preferences.setString('address', Constants.userdata.address);
          preferences.setString('phone_no', Constants.userdata.phone_no);
          preferences.setString('user_type', Constants.userdata.user_type);

          preferences.setString('gender', Constants.userdata.gender);
          preferences.setString('user_lat', Constants.userdata.user_lat);
          preferences.setString('user_long', Constants.userdata.user_long);
          preferences.setString('photo_url', Constants.userdata.photo_url);
          preferences.setString('bus_id', Constants.userdata.bus_id);


          // Constants.myName = Constants.userdata.fullName;
          // Constants.myEmail = Constants.userdata.email;



          if(Constants.userdata.user_type == "DRIVER")
          {

            if(Constants.userdata.bus_id != "")
              {
                await BusRepository().getBusInfo(Constants.userdata.bus_id);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    DriverMainPage()), (Route<dynamic> route) => false);
              }
            else
              {
                showSnackBar("Please contact to Admin, to assign a bus to you");
              }

          }
          else if(Constants.userdata.user_type == "PARENT")
          {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                parentHomeScreen()), (Route<dynamic> route) => false);
          }
          showSnackBar("Login Successfully");

        }).catchError((e) {
          showSnackBar(e.message);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Constants.height = MediaQuery.of(context).size.height;
    Constants.width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: Constants.height/13,
                ),
                Image.asset("assets/images/second_logo.png"
                    , height: 100,width: 100),
                SizedBox(
                  height: 20.0,
                ),
                Text("Welcome",style: CustomTextStyle.splashWelcome(90,90,100,Colors.black),
                ),
                SizedBox(
                  height: Constants.height/15,
                ),
                Padding(padding: const EdgeInsets.symmetric(
                  vertical: 16.0, horizontal: 32.0,
                ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "User Name",
                          labelText: "Enter a User name",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Username cannot be empty";
                          }

                          return null;
                        },
                        onChanged: (value) {
                          name = value;
                          setState(() {});
                        },

                      ),
                      SizedBox(
                        height: Constants.height/35,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: "Enter password",
                          labelText: "Password",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password cannot be empty";
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: Constants.height/13,
                      ),
                      centerButton(
                          Constants.height / 14,
                          Constants.width * 0.50,
                          Constants.width * 0.10,
                          ColorConstants.primaryColor,
                          ColorConstants.blackColor,
                          "Login",
                          login,
                          context),
                      SizedBox(height: 30.0),
                      SizedBox(
                          height: 10.0
                      ),
                      Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                          children: [
                             Text(
                              "Are You a new User?", style: TextStyle(
                                fontSize: 17, color: Colors.black),
                            ),
                            InkWell(
                              onTap: () {

                                Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                             SignupScreen()
                        ));
                              },
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Text('Sign up', style: TextStyle(fontSize: 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Text(
                          "Or Sign in with", style: TextStyle(
                            fontSize: 17, color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: 100.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                },
                              child:
                                  Padding(
                                      padding:EdgeInsets.fromLTRB(25.0,7.0,10.0,10.0),
                                    child:Image.asset("assets/images/fb.png",
                                        height: 50.0,
                                        width: 50.0,
                                        alignment: Alignment.center
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }


}
