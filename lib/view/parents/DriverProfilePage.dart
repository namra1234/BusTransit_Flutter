import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  const DriverProfilePage({Key? key}) : super(key: key);

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
  Gender? gender = Gender.male;
  final Geolocator geolocator = Geolocator();

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    fullNameController = TextEditingController();
    addressController = TextEditingController();
    postalCodeController = TextEditingController();
    phoneNoController = TextEditingController();

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
                                       controller: emailController,
                                       decoration: const InputDecoration(
                                         labelStyle:
                                         TextStyle(color: Colors.black),
                                         hintText: "Email",
                                         labelText: "Enter Email",
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
                                       decoration: const InputDecoration(
                                         labelStyle:
                                         TextStyle(color: Colors.black),
                                         hintText: "Fullname",
                                         labelText: "Enter Fullname",
                                       ),
                                       validator: (value) {
                                         if (value!.isEmpty) {
                                           return "Field can not be empty";
                                         }

                                         return null;
                                       },
                                     ),
                                     InkWell(
                                       child: TextFormField(
                                         readOnly: true,
                                         controller: addressController,
                                         decoration:  InputDecoration(
                                           labelStyle:
                                           const TextStyle(color: Colors.black),
                                           hintText: "Address",
                                           labelText: "Enter Address",
                                           suffixIcon:  InkWell(
                                             child: Icon(
                                               Icons.my_location,
                                               color: ColorConstants.blackColor,
                                             ),
                                           ),
                                         ),
                                         validator: (value) {
                                           if (value!.isEmpty) {
                                             return "Field can not be empty";
                                           }
                                           return null;
                                         },
                                       ),
                                     ),
                                     TextFormField(
                                       controller: phoneNoController,
                                       decoration: const InputDecoration(
                                         labelStyle:
                                         TextStyle(color: Colors.black),
                                         hintText: "Phone No",
                                         labelText: "Enter Phone No",
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
                                     Container(
                                       child: Row(
                                         children: <Widget>[
                                           Container(
                                             width:Constants.width/3.25,
                                             child: Expanded(
                                               child: RadioListTile<Gender>(
                                                 contentPadding: EdgeInsets.only( // Add this
                                                     left: 0,
                                                     right: 0,
                                                     bottom: 0,
                                                     top: 0
                                                 ),
                                                 title:  Align(
                                                     alignment: Alignment(-2.1, 0),
                                                     child: Text('Male')),
                                                 value: Gender.male,
                                                 groupValue: gender,
                                                 onChanged: (Gender? value) {
                                                   setState(() {
                                                     gender = value;
                                                   });
                                                 },
                                               ),
                                             ),
                                           ),
                                           Expanded(
                                             child: RadioListTile<Gender>(
                                               contentPadding: EdgeInsets.only( // Add this
                                                   left: 0,
                                                   right: 0,
                                                   bottom: 0,
                                                   top: 0
                                               ),
                                               title:  Align(
                                                   alignment: Alignment(-1.3, 0),
                                                   child: Text('Female')),
                                               value: Gender.female,
                                               groupValue: gender,
                                               onChanged: (Gender? value) {
                                                 setState(() {
                                                   gender = value;
                                                 });
                                               },
                                             ),
                                           ),
                                         ],
                                       ),
                                     ),
                                     SizedBox(
                                       height: 20,
                                     ),

                                     UserType.DRIVER == _userType ? DropDownMultiSelect (
                                       onChanged: (List<String> x) {
                                         setState(() {
                                           selectedSchool =x;
                                         });
                                       },
                                       options: allschool,
                                       selectedValues: selectedSchool,
                                       whenEmpty: 'Select School',
                                     ): Container(),
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
