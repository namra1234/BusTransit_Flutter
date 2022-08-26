import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:school_bus_transit/common/util.dart';
import 'package:school_bus_transit/repository/busRep.dart';
import 'package:school_bus_transit/view/authentication/login.dart';
import 'package:school_bus_transit/view/parents/ParentProfile.dart';
import 'package:school_bus_transit/view/parents/parentBusTrack.dart';
import 'package:school_bus_transit/view/parents/parentNotification.dart';
import 'package:school_bus_transit/widget/BottomBar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/colorConstants.dart';
import 'package:school_bus_transit/common/constants.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';



class parentHomeScreen extends StatefulWidget{


  parentHomeScreen({Key? key}) : super(key: key);

  @override
  _parentHomeScreenState createState() => _parentHomeScreenState();

}

class _parentHomeScreenState extends State<parentHomeScreen>{


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
                        LoginScreen()),(Route<dynamic> route) => false);
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

  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  late int currentIndex;
  bool loading =true;



  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ),);
  }

  @override
  void initState() {
    super.initState();
    getData();
    currentIndex=1;
  }

  void getData() async
  {
    loading = true;
    setState(() {

    });
    await new BusRepository().getParentScreenDetils(Constants.userdata.school_id);
    setState(() {

      print(Constants.parentScreenData.length);
      loading = false;
    });
  }

  changePage(int? index) {
    setState(() {
      currentIndex = index!;
    });
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBar(),
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text("Welcome "+Constants.userdata.fullName),
            ),
            IconButton(
              icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                onPressed: _showDialog
            ),
          ],

        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: currentIndex == 1
          ? SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[
                titleSection(),
                driverList(),
              ],
            ),
          ),
        ),
      )
          : currentIndex == 0 ? ParentNotification()
          : ParentProfile(),
    );
  }

  Widget BottomBar() {
    return BubbleBottomBar(
      hasNotch: true,
      opacity: 0.2,
      currentIndex: currentIndex,
      onTap: changePage,
      backgroundColor: ColorConstants.primaryColor,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ), //border radius doesn't work when the notch is enabled.
      elevation: 8,
      tilesPadding: EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      items: <BubbleBottomBarItem>[
        BubbleBottomBarItem(
            backgroundColor: Colors.black,
            icon: Icon(
              Icons.notifications,
              color: ColorConstants.bottomBarIconColor,
            ),
            activeIcon: Icon(
              Icons.notifications,
              color: Colors.black,
            ),
            title: Text("Notifications")),
        BubbleBottomBarItem(
          backgroundColor: Colors.black,
          icon: Icon(
            Icons.home,
            color: ColorConstants.bottomBarIconColor,
          ),
          activeIcon: Icon(
            Icons.home,
            color: Colors.black,
          ),
          title: Text("Home"),
        ),
        BubbleBottomBarItem(
            backgroundColor: Colors.black,
            icon: Icon(
              Icons.person,
              color: ColorConstants.bottomBarIconColor,
            ),
            activeIcon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            title: Text("Profile"))
      ],
    );
  }

  Widget titleSection(){
    return Container(child: Text("· List Of All Bus ·",style: const TextStyle(fontSize: 40,)),margin: const EdgeInsets.all(20),);
  }

  Widget driverList(){
    return Container(
      child: loading ? Center(
          child: CircularProgressIndicator(
            color: ColorConstants.primaryColor,
          )) :ListView.builder(
          itemCount: Constants.parentScreenData.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(left:20,right: 20,top: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  onTap: ()
                  {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            parentBusTrack(bus_id:Constants.parentScreenData[index].bus_id)
                    ));
                  },
                child : Container(
                  decoration: BoxDecoration(
                    color: ColorConstants.primaryColor,
                  ),
                  child: Row(
                    children: [
                      SizedBox( width : 10),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                            onTap: ()
                            {

                            },
                            child: DriverProfileImage(Constants.parentScreenData[index].photo_url)
                        ),
                      ),
                      SizedBox( width : 10),
                      Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(Constants.parentScreenData[index].busNumber,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                              Text(Constants.parentScreenData[index].toSchool? "Going To School" : "",style: TextStyle(fontSize: 12),textAlign: TextAlign.center),
                              Text(Constants.parentScreenData[index].driverName,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                            ],
                          )),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [

                            SizedBox(height: 2,),
                            Padding(
                              padding:  EdgeInsets.only(right: 10),
                              child: Bouncing(
                                onPress: () async{
                                  // makingPhoneCall(driverModel.phone_no.toString());
                                  String number = Constants.parentScreenData[index].phone_no.toString();
                                    var url = Uri.parse("tel:+1 $number");
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                },
                                child: RaisedButton(
                                  padding: const EdgeInsets.only(left: 40,right: 42,top: 12,bottom: 12),
                                  onPressed: () async {
                                    String number = Constants.parentScreenData[index].phone_no.toString();
                                    var url = Uri.parse("tel:+1 $number");
                                    if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                    } else {
                                    throw 'Could not launch $url';
                                    }
                                  },
                                  color: ColorConstants.TripOnColor,
                                  child: Icon(Icons.call,size: 30,),
                                ),
                              ),
                            ),
                          ],
                        ),),
                    ],
                  ),
                )),
              ),
            );
          }),
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


}