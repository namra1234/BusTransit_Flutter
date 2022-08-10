import 'package:flutter/material.dart';
import 'dart:math';

import 'package:school_bus_transit/common/constants.dart';

class ParentNotification extends StatefulWidget {

  const ParentNotification({Key? key}) : super(key: key);

  @override
  State<ParentNotification> createState() => _ParentNotificationState();
}

class _ParentNotificationState extends State<ParentNotification> {

  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();


  final List _notifications = [
    'Notification 20',
    'Notification 19',
    'Notification 18',
    'Notification 17',
    'Notification 16'
  ];

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              SizedBox(
                height: Constants.height*0.80,
                child: ListView.builder(
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      return titleSection();
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleSection() {
    return Padding(
      padding:  EdgeInsets.only(left:20,right:20,top:10),
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8.0),
          child: Column(
            children: [
              SizedBox(
                height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Notification 20", style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold),),
                    Text("2:35 pm", style: TextStyle(fontSize: 15.0),)
                  ],
                ),
              ),
              Container(

                color: Colors.amber,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    //controller: titleController,
                    Text("Issues",
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.only(left:10,right: 10,bottom: 10),
                      child: Text("Due to Engine issues, We need to stop or bus at Sicard Rue. All students are safe . There will be 5 minutues to solve problem. We will solve it and we will move soon. Don’t worry about your childrens.",
                        style: TextStyle(fontSize: 15.0),),
                    ),
                  ],
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}

