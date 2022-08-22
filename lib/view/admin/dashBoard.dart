import 'package:flutter/material.dart';
import 'package:school_bus_transit/common/buttonStyle.dart';
import 'package:school_bus_transit/common/colorConstants.dart';
import 'package:school_bus_transit/common/textStyle.dart';
import 'package:school_bus_transit/view/admin/schoolSection.dart';
import 'package:school_bus_transit/view/authentication/login.dart';
import 'package:school_bus_transit/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../repository/busRep.dart';
import '../../repository/schoolRep.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {

  int schoolCount = 0, busCount = 0, driverCount = 0;


  void showSnackBar(String message) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ),);

  }
  void _showDialog(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Sign out",),
            content: Text("are you sure want to signout?",style:
            TextStyle(fontSize: 18.0),),
            actions: [
              MaterialButton(
                onPressed: (){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (context) =>
                          LoginScreen()
                  ),(Route<dynamic> route) => false);
                },
                child: Text("yes",style: TextStyle(fontSize: 15.0),),
              ),
              MaterialButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("no",style: TextStyle(fontSize: 15.0),),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    schoolCount = 0;
    busCount = 0;
    driverCount = 0;
    getSchoolCount();
    getBusCount();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Welcome Admin",textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,fontWeight: FontWeight.bold
        ),
      ),
      ),
      backgroundColor: ColorConstants.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [

                      Padding(
                        padding:  EdgeInsets.only(left:20,right:30,top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            InkWell(
                              onTap: () {
                                // print("hello");

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        SchoolSection()
                                )).then((value) => {
                                getSchoolCount(),
                                    getBusCount()
                                });

                              },
                              child: Container(
                                height: 150,
                                width: 150,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10.0)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "$schoolCount",textAlign: TextAlign.center,style:
                                    TextStyle(
                                        fontSize: 40,color: Colors.black,fontWeight: FontWeight.bold
                                    ),
                                    ),
                                    Text(
                                      "#Schools",textAlign: TextAlign.start,style:
                                    TextStyle(
                                        fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold
                                    ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            InkWell(
                              onTap: () {},
                              child: Container(
                                height: 150,
                                width: 150,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10.0)
                                ),

                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Text(
                                      "#Bus",textAlign: TextAlign.end,style:
                                    TextStyle(
                                        fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold
                                    ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                      children: [

                                        Text(
                                          "$busCount",textAlign: TextAlign.left,style:
                                        TextStyle(
                                            fontSize: 40,color: Colors.white,fontWeight: FontWeight.bold
                                        ),
                                        ),
                                        Icon(Icons.bus_alert_rounded,color: Colors.black,size: 40.0,),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.only(left:20,right:30,top: 20),
                          child: Container(
                            height: 150,
                            width: 350,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10.0)
                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "#Driver List",textAlign: TextAlign.start,style:
                                TextStyle(
                                    fontSize: 40,color: Colors.black,fontWeight: FontWeight.bold
                                ),
                                ),
                                Text(
                                  "$driverCount",textAlign: TextAlign.center,style:
                                TextStyle(
                                    fontSize: 40,color: Colors.black,fontWeight: FontWeight.bold
                                ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),


                InkWell(
                  onTap: () {
                    _showDialog();
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0,300.0,20.0,20.0),
                      child: AnimatedContainer(duration: Duration(seconds: 1),
                        alignment: Alignment.center,
                        height: 60,width: 350,
                        child: Text("Logout",
                          style: TextStyle(fontSize: 40,color: Colors.white,fontWeight: FontWeight.bold,
                        ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,borderRadius: BorderRadius.circular(10.0)
                        ),
                      ),

                    ),

                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  getSchoolCount() async {
    schoolCount = await SchoolRepository().SchoolCount();
    setState(() {});
  }

  getBusCount() async {
    busCount = await BusRepository().BusCount();
    setState(() {});
  }


}
