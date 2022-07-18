import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_bus_transit/model/schoolModel.dart';
import 'package:school_bus_transit/repository/driverRep.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:avatar_glow/avatar_glow.dart';

import '../../common/colorConstants.dart';
import '../../common/constants.dart';
import '../../common/textStyle.dart';
import '../../common/util.dart';
import '../../model/busModel.dart';
import '../../model/userModel.dart';
import '../../repository/busRep.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverSection extends StatefulWidget{
  SchoolModel school_;
  BusModel bus_;

  DriverSection({Key? key, required this.school_,required this.bus_}) : super(key: key);

  @override
  _DriverSectionState createState() => _DriverSectionState();

}


class _DriverSectionState extends State<DriverSection>{

  bool loading = true;
  int driverCount = 0;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ),);
  }

  @override
  void initState() {
    super.initState();
    getDriverList();

    print(widget.school_.name + "  --- > DriverSection class");
    print(widget.bus_.bus_number.toString() + " --->  DriverSection");
  }

  @override
  void dispose() {
    super.dispose();
  }

  getDriverList() async
  {
    List<UserModel> driverList = [];
    print("calling driverSection -> getDriverList()");
    driverList = await DriverRepository().getAllNonAllocatedDriver();
    Constants.driverList.clear();
    setState(() {
      Constants.driverList.addAll(driverList);
      driverCount = driverList.length;
      loading = false;
    });
  }

  getDriverAssign(String driver_id) async
  {
    print("calling driverSection -> getDriverAssign()");
    await DriverRepository().updateDriverSpecificDetails("bus_id", widget.bus_.bus_id, driver_id);
    Navigator.pop(context);
  }

  deleteBus(String bus_id) async
  {
    print("calling driverSection -> deleteBus()");
    await BusRepository().deleteBus(bus_id);
    Navigator.pop(context);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Driver Allocation",textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20,fontWeight: FontWeight.bold
        ),
      ),
      ),
      backgroundColor: ColorConstants.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[
                titleSection(),
                BusDetailSection(),
                titleDriverSection(),
                DriverListSection(),
                deleteDriver(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleSection(){
    String busNumber = widget.bus_.bus_number.toString();
    return Container(
      child: Text("Bus Number : $busNumber",style: TextStyle(fontSize: 25,)),
      // color: ColorConstants.titleGreyColor,
      padding: EdgeInsets.only(top: 10,bottom: 10),
      width: Constants.width,
      margin: EdgeInsets.only(top: 20,left: 20,right: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: ColorConstants.titleGreyColor,
      ),
    );
  }

  Widget BusDetailSection(){
    return ZoomTapAnimation(
      child: Card(
        child: Column(
          children: <Widget>[
            const ListTile(
              title: Text("School name",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(widget.school_.name, style: TextStyle(fontSize: 20,)),
            ),

            const ListTile(
              title: Text("School Address",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(widget.school_.address, style: TextStyle(fontSize: 20,)),
            ),

            const ListTile(
              title: Text("Terminal Address",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(widget.bus_.destination, style: TextStyle(fontSize: 20,)),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
        elevation: 8,
        shadowColor: Colors.black,
        color: ColorConstants.primaryColor,
        margin: EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 10),
        shape:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey, width: 0)
        ),

      ),
    );
  }

  Widget titleDriverSection(){
    return Container(
      child: Text("Driver List ( $driverCount )",style: TextStyle(fontSize: 17,)),
      // color: ColorConstants.titleGreyColor,
      padding: EdgeInsets.only(top: 10,bottom: 10),
      width: Constants.width,
      margin: EdgeInsets.only(left: 20,right: 20),
      alignment: Alignment.center,
    );
  }

  //----------------- driver list widget group -----------------------
  Widget DriverListSection(){
    return Constants.driverList.length != 0
        ? Padding(
      padding: EdgeInsets.only(
          top: Constants.height * 0.03,
          left: Constants.width * 0.01,
          right: Constants.width * 0.01),
      child: Container(
        child: ListView.builder(
            itemCount: Constants.driverList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DriverListView(Constants.driverList[index], index),
                  SizedBox(
                    height: 10,
                  )
                ],
              );
            }),
      ),
    )
        : loading
        ? Center(
        child: CircularProgressIndicator(
          color: ColorConstants.schoolListColor,
        ))
        : Center(
        child: Text("Please Add Driver!",
            style: CustomTextStyle.mediumText(25, Constants.width)
                .apply(fontStyle: FontStyle.italic)));
  }

  Widget DriverListView(UserModel driverModel, int index) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: const BoxDecoration(
            color: ColorConstants.primaryColor,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return DetailScreen(img_url:driverModel.photo_url);
                            }));
                          },
                          child: DriverProfileImage(driverModel.photo_url)
                      )
                    ],
                  ),
              ),
              Expanded(
                flex: 5,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(driverModel.fullName,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                ],
              )),
              Expanded(
                flex: 3,
                child: Column(
                children: [
                  Container(

                    child: Bouncing(
                      onPress: (){
                        
                      },
                      child: RaisedButton(
                          padding: const EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
                          onPressed: () {
                            getDriverAssign(driverModel.user_id);
                          },
                          color: ColorConstants.TripOnColor,
                          child: const Text('Allocate',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),)),
                    ),
                  ),
                  SizedBox(height: 2,),
                  Bouncing(
                    onPress: () async{
                      // makingPhoneCall(driverModel.phone_no.toString());
                      // String number = driverModel.phone_no.toString();
                      //   var url = Uri.parse("tel:+1 $number");
                      //   if (await canLaunchUrl(url)) {
                      //     await launchUrl(url);
                      //   } else {
                      //     throw 'Could not launch $url';
                      //   }
                    },
                    child: RaisedButton(
                      padding: const EdgeInsets.only(left: 40,right: 42,top: 12,bottom: 12),
                      onPressed: () {  },
                      color: ColorConstants.TripOnColor,
                      child: Icon(Icons.call,size: 30,),
                    ),
                  ),
                ],
              ),),
            ],
          ),
        ),
    );
  }

  Widget DriverProfileImage(String ImgUrl){
    print(ImgUrl);
    return AvatarGlow(
      endRadius: 50.0,
      child: Material(     // Replace this child with your own
        elevation: 8.0,
        shape: CircleBorder(),
        child: CircleAvatar(
          backgroundColor: Colors.green[100],
          child: Image.network(ImgUrl,height: 50,),
          radius: 30.0,
        ),
      ),
    );
  }

  //----------------------------------------------------------------

  Widget deleteDriver(){
    return Container(
      width: Constants.width*0.8,
      // color: ColorConstants.DeleteButtonColor,
      margin: EdgeInsets.only(top: 10,bottom: 20),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: ColorConstants.DeleteButtonColor,
          primary: Colors.white,
          elevation: 10,
        ),
        child: Text("Delete Bus", style: TextStyle(fontSize: 20.0),),

        onPressed: () {


          deleteBus(widget.bus_.bus_id);

          print("Delete Bus");
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
