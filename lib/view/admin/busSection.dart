import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_bus_transit/model/schoolModel.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../common/colorConstants.dart';
import '../../common/constants.dart';
import '../../common/textStyle.dart';
import '../../model/busModel.dart';
import '../../repository/busRep.dart';
import 'addBusScreen.dart';

class BusSection extends StatefulWidget{
  SchoolModel school_;

  BusSection({Key? key, required this.school_}) : super(key: key);

  @override
  _BusSectionState createState() => _BusSectionState();

}

class _BusSectionState extends State<BusSection>{

  bool loading = true;
  int busCount = 0;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ),);
  }

  @override
  void initState() {
    super.initState();
    getBusList(widget.school_.school_id);
    busCount = Constants.busList.length;
    print(widget.school_.name);
  }

  @override
  void dispose() {
    super.dispose();
  }

  getBusList(String school_id) async
  {
    List<BusModel> busList = [];
    print("calling");
    busList = await BusRepository().getAllBus(school_id);
    Constants.busList.clear();
    setState(() {
      Constants.busList.addAll(busList);
      // print("$Constants.$schoolList.$length);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bus Section",textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20,fontWeight: FontWeight.bold
        ),
      ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle,size: 35,),
            onPressed: () {

              print("Add new Bus");
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AddBusScreen(school_:widget.school_)
              )).then((value) => {getBusList(widget.school_.school_id)});
            },
          ),
          // add more IconButton
        ],
      ),
      backgroundColor: ColorConstants.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[
                titleSection(),
                schoolDetailSection(),
                titleBusSection(),
                BusListSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleSection(){
    return Container(
      child: Text(widget.school_.name,style: TextStyle(fontSize: 25,)),
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

  Widget schoolDetailSection(){
    return ZoomTapAnimation(
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Email",style: TextStyle(fontSize: 25),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(widget.school_.email_id, style: TextStyle(fontSize: 20,)),
            ),

            ListTile(
              title: Text("Phone",style: TextStyle(fontSize: 25),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(widget.school_.phone_no, style: TextStyle(fontSize: 20,)),
            ),

            ListTile(
              title: Text("Address",style: TextStyle(fontSize: 25),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(widget.school_.address, style: TextStyle(fontSize: 20,)),
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

  Widget titleBusSection(){
    return Container(
      child: Text("Bus Section ( $busCount )",style: TextStyle(fontSize: 17,)),
      // color: ColorConstants.titleGreyColor,
      padding: EdgeInsets.only(top: 10,bottom: 10),
      width: Constants.width,
      margin: EdgeInsets.only(left: 20,right: 20),
      alignment: Alignment.center,
    );
  }

  Widget BusListSection(){
    return Constants.busList.length != 0
        ? Padding(
      padding: EdgeInsets.only(
          top: Constants.height * 0.03,
          left: Constants.width * 0.01,
          right: Constants.width * 0.01),
      child: Container(
        child: ListView.builder(
            itemCount: Constants.busList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BusListView(Constants.busList[index], index),
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
        child: Text("Please Add Bus!",
            style: CustomTextStyle.mediumText(25, Constants.width)
                .apply(fontStyle: FontStyle.italic)));
  }

  Widget BusListView(BusModel busModel, int index) {
    double c_width = MediaQuery.of(context).size.width*0.6;
    return ZoomTapAnimation(
      onTap: () {
        print("clicked");
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             AddDishes(dish_: dishModel, index: index)))
        //     .then((value) => {getDishList()});
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            color: ColorConstants.schoolListColor,
          ),
          child: Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                alignment: Alignment.topCenter,
                color: Colors.green,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: ClipRRect(
                    child: Text(busModel.bus_number.toString(),style: TextStyle(fontSize: 40,color: Colors.white),),
                  ),
                ),
              ),
              Container(
                // width: Constants.width*0.65,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: ClipRRect(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("Trip : ",style: TextStyle(fontSize: 25),textAlign: TextAlign.left,),
                            Text(busModel.active_sharing ? "   ON" : "   OFF",style: TextStyle(fontSize: 25,color: busModel.active_sharing ? ColorConstants.TripOnColor : ColorConstants.TripOffColor,),textAlign: TextAlign.left,)
                          ],
                        ),
                        SizedBox(height: 5,),
                        Container(
                          width: c_width,
                          child: Text(busModel.destination,style: TextStyle(fontSize: 15,color: busModel.active_sharing ? ColorConstants.TripOnColor : ColorConstants.TripOffColor,),textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}