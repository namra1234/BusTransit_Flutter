import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_bus_transit/repository/userRep.dart';

import '../../common/buttonStyle.dart';
import '../../common/colorConstants.dart';
import '../../common/constants.dart';
import '../authentication/signup.dart';
import 'package:multiselect/multiselect.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:geolocator/geolocator.dart';
import 'package:map_address_picker/models/location_result.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';


const kGoogleApiKey = "AIzaSyAgpLONoQLPhvXWh05qs8cCBdmZS9NDolw";
final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);


class DriverProfilePage extends StatefulWidget {
  final String bus_id;
   DriverProfilePage({Key? key,required this.bus_id}) : super(key: key);

  @override
  State<DriverProfilePage> createState() => _DriverProfilePageState();
}
enum UserType { PARENT, DRIVER }
enum Gender { male, female }

class _DriverProfilePageState extends State<DriverProfilePage> {
  List<String> allschool = ['Cegep Gim','ISI','Concordia','Lasaale'];
  List<String> selectedSchool = [];
  bool uploadingImage=false;
  String uploadedFileURL = "";
  double lattitude = 0;
  double longitude = 0;

  String name = "";
  bool changeButton = false;
  late TextEditingController emailController,
      fullNameController,
      addressController,
      postalCodeController,
      phoneNoController;


  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  UserType? _userType = UserType.PARENT;
  String gender = "";
  final Geolocator geolocator = Geolocator();

  @override
  void initState() {
    super.initState();
    getData();
    emailController = TextEditingController();
    fullNameController = TextEditingController();
    addressController = TextEditingController();
    postalCodeController = TextEditingController();
    phoneNoController = TextEditingController();

  }

  void getData() async
  {
    await new UserRepository().getDriver(widget.bus_id);
    emailController.text = Constants.selectedDriverByParentdata.email_id;
    fullNameController.text = Constants.selectedDriverByParentdata.fullName;
    phoneNoController.text = Constants.selectedDriverByParentdata.phone_no;
    uploadedFileURL=Constants.selectedDriverByParentdata.photo_url;
    gender = Constants.selectedDriverByParentdata.gender;
    setState(() {

    });
  }

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    fullNameController.dispose();
    addressController.dispose();
    postalCodeController.dispose();
    phoneNoController.dispose();

  }

  LocationResult? locationResult;

  @override
  Widget build(BuildContext context) {
     Constants.height = MediaQuery.of(context).size.height;
     Constants.width = MediaQuery.of(context).size.width;

     return Scaffold(
       appBar: AppBar(
         backgroundColor: ColorConstants.primaryColor,
         title: Row(
           children: [
             Padding(
               padding: EdgeInsets.all(5.0),
               child: Text("Driver Profile"),
             )
           ],
         ),
         elevation: 0.0,
         centerTitle: false,
       ),
      body: SafeArea(
        child: Stack(
             children: [
               SingleChildScrollView(
                 child: Padding(
                   padding: EdgeInsets.only(top:Constants.height/15,left:Constants.width/18,right:Constants.width/18),
                   child: Column(
                     children: [
                       Form(
                         key: _formKey,
                         child: Column(
                           children: <Widget>[
                             const SizedBox(
                               height: 20.0,
                             ),
                             Text(
                               "Driver Profile",
                               style: const TextStyle(
                                   fontSize: 30,
                                   fontWeight: FontWeight.bold),
                             ),

                             Padding(
                               padding:  EdgeInsets.only(top:10),
                               child: GestureDetector(
                                   onTap: () {

                                   },
                                   child: Center(
                                     child: uploadedFileURL == "" ?
                                     Container(
                                         height: Constants.height * 0.12,
                                         width: Constants.height * 0.12,
                                         decoration: BoxDecoration(
                                             shape: BoxShape.circle,
                                             image: new DecorationImage(
                                                 fit: BoxFit.cover,
                                                 image:
                                                 AssetImage('assets/images/person.png'))))
                                         :  ClipRRect(
                                       borderRadius: BorderRadius.circular(Constants.height * 0.12),
                                       child: Image.network(
                                         uploadedFileURL,
                                         height: Constants.height * 0.12,
                                         width: Constants.height * 0.12,
                                         fit: BoxFit.fill,
                                         errorBuilder: (context, error, stackTrace) {
                                           return Container(
                                             child: ClipRRect(
                                               borderRadius: BorderRadius.circular(20),
                                               child: Image.asset(
                                                 'assets/images/person.png',
                                                 height: Constants.height * 0.12,
                                                 width: Constants.height * 0.12,
                                                 fit: BoxFit.fill,
                                               ),
                                             ),
                                           );
                                         },
                                       ),
                                     ),
                                   )
                               ),
                             ),
                             Container(
                               child: Padding(
                                 padding: EdgeInsets.symmetric(
                                     vertical: 17, horizontal: 20),
                                 child: Column(
                                   children: [
                                     TextFormField(
                                       enabled: false,
                                       controller: emailController,
                                       decoration: const InputDecoration(
                                         labelStyle:
                                         TextStyle(color: Colors.black),
                                         hintText: "Email",
                                         labelText: "Email",
                                       ),
                                       validator: (value) {
                                         String emailPattern =
                                             '([a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+)';
                                         RegExp regExp =
                                         RegExp(emailPattern);
                                         if (value!.isEmpty) {
                                           return "Field can not be empty";
                                         } else if (!regExp
                                             .hasMatch(value)) {
                                           return "Invalid email address";
                                         }
                                         return null;
                                       },
                                       onChanged: (value) {
                                         name = value;
                                         setState(() {});
                                       },
                                     ),
                                     TextFormField(
                                       controller: fullNameController,
                                       enabled: false,
                                       decoration: const InputDecoration(
                                         labelStyle:
                                         TextStyle(color: Colors.black),
                                         hintText: "Fullname",
                                         labelText: "Fullname",
                                       ),
                                       validator: (value) {
                                         if (value!.isEmpty) {
                                           return "Field can not be empty";
                                         }

                                         return null;
                                       },
                                     ),
                                     // InkWell(
                                     //   child: TextFormField(
                                     //     readOnly: true,
                                     //     controller: addressController,
                                     //     decoration:  InputDecoration(
                                     //       labelStyle:
                                     //       const TextStyle(color: Colors.black),
                                     //       enabled: false,
                                     //       hintText: "Address",
                                     //       labelText: "Address",
                                     //       suffixIcon:  InkWell(
                                     //         child: Icon(
                                     //           Icons.my_location,
                                     //           color: ColorConstants.blackColor,
                                     //         ),
                                     //       ),
                                     //     ),
                                     //     validator: (value) {
                                     //       if (value!.isEmpty) {
                                     //         return "Field can not be empty";
                                     //       }
                                     //       return null;
                                     //     },
                                     //   ),
                                     // ),
                                     TextFormField(
                                       controller: phoneNoController,
                                       enabled: false,
                                       decoration: const InputDecoration(
                                         labelStyle:
                                         TextStyle(color: Colors.black),
                                         enabled: false,
                                         hintText: "Phone No",
                                         labelText: "Phone No",
                                       ),
                                       validator: (value) {
                                         String phonePattern =
                                             '^\d{3}-\d{3}-\d{4}\$';
                                         RegExp regExp =
                                         RegExp(phonePattern);
                                         if (value!.isEmpty) {
                                           return "Field can not be empty";
                                         }
                                         // else if (!regExp.hasMatch(value)) {
                                         //   return "invalid format [ 514-xxx-xx66 ]";
                                         // }

                                         return null;
                                       },
                                     ),
                                     SizedBox(
                                       height: 20,
                                     ),
                                     Align(
                                       alignment: Alignment.centerLeft,
                                       child: Text(
                                         "Gender",
                                         style: TextStyle(
                                             fontSize: 17, color: Colors.black),
                                       ),
                                     ),
                                     Padding(
                                       padding:  EdgeInsets.only(top: 10),
                                       child: Align(
                                         alignment: Alignment.centerLeft,
                                         child: Text(
                                           gender,
                                           style: TextStyle(
                                               fontSize: 17, color: Colors.black),
                                         ),
                                       ),
                                     ),

                                   ],
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),
                       SizedBox(height: 30),
                     ],
                   ),
                 ),
               ),
             ],

        ),
      ),
    );
  }
}
