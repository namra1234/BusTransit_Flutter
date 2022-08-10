import 'package:flutter/material.dart';
import 'dart:math';

import 'package:school_bus_transit/common/constants.dart';

import '../../common/colorConstants.dart';
import '../../model/notificationModel.dart';
import '../../repository/notificationRep.dart';

class ParentNotification extends StatefulWidget {

  const ParentNotification({Key? key}) : super(key: key);

  @override
  State<ParentNotification> createState() => _ParentNotificationState();
}

class _ParentNotificationState extends State<ParentNotification> {

  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<NotificationModel> notificationData=[];
  bool loading=true;


  final List _notifications = [
    'Notification 20',
    'Notification 19',
    'Notification 18',
    'Notification 17',
    'Notification 16'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotification();

  }
  void getNotification() async
  {
    notificationData=await new NotificationRepository().getAllBusNotification(Constants.userdata.school_id);

    setState(() {
      loading = false;
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
                child: loading ?
                Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.primaryColor,
                  ),
                ):

                notificationData.length!=0 ?
                ListView.builder(
                    itemCount: notificationData.length,
                    itemBuilder: (context, index) {
                      return titleSection(notificationData[index],index);
                    }
                ):
                Container(
                  child:Center(child: Text("There is no notification.",
                    style: TextStyle(
                      fontSize: 20,fontWeight: FontWeight.bold
                  ),))
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleSection(NotificationModel notification , int index) {

    int num = notificationData.length - index;
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
                  children:  [
                    Text("Notification "+num.toString(), style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold),),
                    Text(notification.timestamp.day.toString()+"-"
                      +notification.timestamp.month.toString()+"-"
                      +notification.timestamp.year.toString()+" "
                        +notification.timestamp.hour.toString()+"-"
                        +notification.timestamp.minute.toString()

                      , style: TextStyle(fontSize: 15.0),)
                  ],
                ),
              ),
              Container(
width: Constants.width,
                color: Colors.amber,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    //controller: titleController,
                    Text(notification.title,
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.only(left:10,right: 10,bottom: 10),
                      child: Text(notification.message,
                        style: TextStyle(fontSize: 15.0),),
                    )
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

