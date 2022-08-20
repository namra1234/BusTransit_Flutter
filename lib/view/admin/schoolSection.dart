import 'package:flutter/material.dart';
import 'package:school_bus_transit/model/schoolModel.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../common/colorConstants.dart';
import '../../common/constants.dart';
import '../../common/textStyle.dart';
import '../../repository/schoolRep.dart';
import 'addSchoolScreen.dart';
import 'busSection.dart';

class SchoolSection extends StatefulWidget{
  @override
  _SchoolSectionState createState() => _SchoolSectionState();

}

class _SchoolSectionState extends State<SchoolSection>{

  bool loading = true;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ),);
  }

  @override
  void initState() {
    super.initState();
    getSchoolList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getSchoolList() async {
    List<SchoolModel> schoolList = [];

    schoolList = await SchoolRepository().getAllSchool();
    // dishdata=await DishRepository().getChefAllDish(Constants.userdata.userID);
    Constants.schoolList.clear();
    setState(() {
      Constants.schoolList.addAll(schoolList);
      // print("$Constants.$schoolList.$length);
      loading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("School Section",textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20,fontWeight: FontWeight.bold
        ),
      ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle,size: 35,),
            onPressed: () {

              print("Add new School");
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AddSchoolScreen()
              ));
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
                SchoolListSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget titleSection(){
    return Container(child: Text("· School List ·",style: TextStyle(fontSize: 35,)),margin: EdgeInsets.all(20),);
  }

  Widget SchoolListSection(){
    return Constants.schoolList.length != 0
        ? Padding(
      padding: EdgeInsets.only(
          top: Constants.height * 0.03,
          left: Constants.width * 0.01,
          right: Constants.width * 0.01),
      child: Container(
        child: ListView.builder(
            itemCount: Constants.schoolList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SchoolListView(Constants.schoolList[index], index),
                  SizedBox(
                    height: 15,
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
        child: Text("Please Add School",
            style: CustomTextStyle.mediumText(25, Constants.width)
                .apply(fontStyle: FontStyle.italic)));
  }

  Widget SchoolListView(SchoolModel schoolModel, int index) {
    return ZoomTapAnimation(
      onTap: () {
        print("clicked");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BusSection(school_: schoolModel)))
            .then((value) => {
            getSchoolList()
            });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.only(left: 15,right: 15),
          decoration: BoxDecoration(
            color: ColorConstants.schoolListColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/scholar_cap.png',
                      height: Constants.height * 0.07,
                      width: Constants.width * 0.14,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(schoolModel.name,style: TextStyle(fontSize: 30),textAlign: TextAlign.center,),

              ),

            ],
          ),
        ),
      ),
    );
  }

}