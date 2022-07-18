import 'package:flutter/material.dart';
import 'package:school_bus_transit/model/notificationModel.dart';

import '../../common/buttonStyle.dart';
import '../../common/colorConstants.dart';

import '../../common/constants.dart';
import '../../model/schoolModel.dart';
import '../../repository/busRep.dart';
import '../../repository/notificationRep.dart';

class DriverNotification extends StatefulWidget{


  DriverNotification({Key? key}) : super(key: key);

  @override
  _DriverNotificationState createState() => _DriverNotificationState();

}

class _DriverNotificationState extends State<DriverNotification>{

  late TextEditingController titleController, descriptionController;

  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ),);
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification Section",textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20,fontWeight: FontWeight.bold
        ),
      ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[
                titleSection(),
                busForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleSection(){
    return Container(child: Text("· Add Notification ·",style: const TextStyle(fontSize: 40,)),margin: const EdgeInsets.all(20),);
  }

  Widget busForm(){
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 17, horizontal: 20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelStyle:
                          TextStyle(color: Colors.black),
                          hintText: "Subject",
                          labelText: "Title of Notification",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Field can not be empty";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        maxLines:8,
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelStyle:
                          TextStyle(color: Colors.black),
                          hintText: "Description",
                          labelText: "What happened?....",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Field can not be empty";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        centerButton(
            Constants.height / 14,
            Constants.width * 0.50,
            Constants.width * 0.10,
            ColorConstants.primaryColor,
            ColorConstants.blackColor,
            "Send Messages",
            validationRegister,
            context),

      ],
    );
  }

  validationRegister() async {
    if (_formKey.currentState!.validate()) {
      sendNotification();
    }
  }

  sendNotification() async {

    NotificationModel newModel = NotificationModel(
        "No Notification Id",
        Constants.CurrentDriverdata.user_id,
        Constants.CurrentDriverdata.bus_id,
        Constants.singleBusData.school_id,
        titleController.text.toString(),
        descriptionController.text.toString(),
        DateTime.now()
    );

    String newNotificationId = await NotificationRepository().addNotification(newModel.toJson());

    if(newNotificationId == "false")
    {
      showSnackBar("Error : There is something wrong!");
      return;
    }

    newModel.notification_id = newNotificationId;
    await NotificationRepository().updateNotification(
        newModel.toJson(),newNotificationId);

    titleController.clear();
    descriptionController.clear();

    showSnackBar("Notification has been send Successfully");

  }

  getBusInfo() async {

    print("calling driverSection -> getDriverList()");
    await BusRepository().getBusInfo(Constants.CurrentDriverdata.bus_id);
    setState(() {    });

  }


}