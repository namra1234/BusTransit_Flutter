import 'package:flutter/material.dart';
import 'package:school_bus_transit/model/schoolModel.dart';
import 'package:school_bus_transit/repository/schoolRep.dart';

import '../../common/buttonStyle.dart';
import '../../common/colorConstants.dart';

import 'package:geolocator/geolocator.dart';
import 'package:map_address_picker/models/location_result.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';

import '../../common/constants.dart';

const kGoogleApiKey = "AIzaSyAgpLONoQLPhvXWh05qs8cCBdmZS9NDolw";
final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();


// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class AddSchoolScreen extends StatefulWidget{
  @override
  _AddSchoolScreenState createState() => _AddSchoolScreenState();

}

class _AddSchoolScreenState extends State<AddSchoolScreen>{

  double lattitude = 0;
  double longitude = 0;

  late TextEditingController schoolNameController,
      emailController,
      contactController,
      addressController;



  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final Geolocator geolocator = Geolocator();
  LocationResult? locationResult;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ),);
  }

  @override
  void initState() {
    super.initState();

    schoolNameController = TextEditingController();
    emailController = TextEditingController();
    contactController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    schoolNameController.dispose();
    emailController.dispose();
    contactController.dispose();
    addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List of Schools",textAlign: TextAlign.center,
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
                schoolForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleSection(){
    return Container(child: Text("· New School ·",style: TextStyle(fontSize: 40,)),margin: EdgeInsets.all(20),);
  }

  Widget schoolForm(){
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
                        controller: schoolNameController,
                        decoration: InputDecoration(
                          labelStyle:
                          TextStyle(color: Colors.black),
                          hintText: "School name",
                          labelText: "Enter School name",
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
                      SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelStyle:
                          TextStyle(color: Colors.black),
                          hintText: "Email",
                          labelText: "Enter Email",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),

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
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        controller: contactController,
                        decoration: InputDecoration(
                          labelStyle:
                          TextStyle(color: Colors.black),
                          hintText: "Phone No",
                          labelText: "Enter Phone No",
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)
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
                      SizedBox(
                        height: 30.0,
                      ),
                      InkWell(
                        onTap: _handlePressButton,
                        child: TextFormField(
                          readOnly: true,
                          controller: addressController,
                          decoration:  InputDecoration(
                            labelStyle:
                            TextStyle(color: Colors.black),
                            hintText: "Address",
                            labelText: "Find School Address",
                            suffixIcon:  InkWell(
                              onTap: _handlePressButton,
                              child: Icon(
                                Icons.my_location,
                                color: ColorConstants.blackColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)
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
                      ),
                      SizedBox(
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
            "Add",
            validationRegister,
            context),

      ],
    );
  }

  validationRegister() async {
    if (_formKey.currentState!.validate()) {
      addSchool();
    }
  }

  addSchool() async {

    SchoolModel newModel = SchoolModel(
      "No School Id",
      schoolNameController.text,
      emailController.text.toString(),
      contactController.text.toString(),
      addressController.text.toString(),
      lattitude.toString(),
      longitude.toString(),
    );

     String newSchoolId = await SchoolRepository().addNewSchool(
       newModel.toJson());

     if(newSchoolId == "false")
       {
         showSnackBar("Error : There is something wrong!");
         return;
       }

      newModel.school_id = newSchoolId;
      await SchoolRepository().updateSchool(
      newModel.toJson(),newSchoolId);


      schoolNameController.clear();
      emailController.clear();
      contactController.clear();
      addressController.clear();

      showSnackBar("School has been created Successfully");

  }


  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState!.showSnackBar(
      SnackBar(content: Text(response.errorMessage!)),
    );
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: Mode.overlay,
      language: "en",
      components: [Component(Component.country, "ca")],
    );

    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p!.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    lattitude = lat;
    longitude =lng;
    addressController.text = p.description!;
    // showSnackBar("${p.description} - $lat/$lng");

    // displayPrediction(p!, homeScaffoldKey.currentState!);
  }

}