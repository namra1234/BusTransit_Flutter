import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';

import 'package:school_bus_transit/common/constants.dart';
import 'package:multiselect/multiselect.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/buttonStyle.dart';
import '../../common/colorConstants.dart';
import '../../model/userModel.dart';
import '../../repository/userRep.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_address_picker/models/location_result.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';



 const kGoogleApiKey = "AIzaSyAgpLONoQLPhvXWh05qs8cCBdmZS9NDolw";
final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();


// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class DriverProfile extends StatefulWidget {
  const DriverProfile({Key? key}) : super(key: key);

  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

enum UserType { PARENT, DRIVER }
enum Gender { male, female }

class _DriverProfileState extends State<DriverProfile> {

  List<String> allschool = ['Cegep Gim','ISI','Concordia','Lasaale'];
  List<String> selectedSchool = [];
  bool uploadingImage=false;
  String uploadedFileURL = "";
  double lattitude = double.parse(Constants.userdata.user_lat);
  double longitude = double.parse(Constants.userdata.user_long);

  String name = "";
  bool changeButton = false;
  late TextEditingController emailController,
      fullNameController,
      addressController,
      postalCodeController,
      phoneNoController;

  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  UserType? _userType = UserType.DRIVER;
  Gender? gender = Gender.male;
  final Geolocator geolocator = Geolocator();

  Save() async {
    if (_formKey.currentState!.validate()) {

      if(selectedSchool.length==0 && _userType==UserType.PARENT)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please select school."),
          ),
        );

      }
      else if(uploadedFileURL=="")
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please select profile photo"),
          ),
        );
      }
      else
      {
        FocusManager.instance.primaryFocus?.unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
        String g="";
        if(gender==Gender.male)
        {
          g="male";
        }
        else
        {
          g="female";
        }

        await UserRepository().updateUser(
            UserModel(
                Constants.userdata.user_id,
                emailController.text,
                fullNameController.text,
                addressController.text,
                uploadedFileURL,
                phoneNoController.text,
                "DRIVER",
                Constants.userdata.bus_id,
                g,
                lattitude.toString(),
                longitude.toString(),
                []
            ),Constants.userdata.user_id
        );

        showSnackBar("Profile Update Successfully");
      }
    }
  }
  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    fullNameController = TextEditingController();
    addressController = TextEditingController();
    postalCodeController = TextEditingController();
    phoneNoController = TextEditingController();

    emailController.text = Constants.userdata.email_id;
    fullNameController.text = Constants.userdata.fullName;
    addressController.text = Constants.userdata.address;
    phoneNoController.text = Constants.userdata.phone_no;
    uploadedFileURL = Constants.userdata.photo_url;

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
           // debugeShowCheckMode==false;

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
                                getImage();
                              },
                              child: new Center(
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
                                  onTap: _handlePressButton,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: addressController,
                                    decoration:  InputDecoration(
                                      labelStyle:
                                      const TextStyle(color: Colors.black),
                                      hintText: "Address",
                                      labelText: "Enter Address",
                                      suffixIcon:  InkWell(
                                        onTap: _handlePressButton,
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
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "User Type",
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.black),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: RadioListTile<UserType>(
                                          contentPadding: EdgeInsets.only( // Add this
                                              left: 0,
                                              right: 0,
                                              bottom: 0,
                                              top: 0
                                          ),
                                          title:  Align(
                                              alignment: Alignment(-1.2, 0),
                                              child: Text('Driver')),
                                          value: UserType.DRIVER,
                                          groupValue: _userType,
                                          onChanged: (UserType? value) {
                                            setState(() {
                                              _userType = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                UserType.DRIVER != _userType ? DropDownMultiSelect (
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

                  SizedBox(
                    height: 10.0,
                  ),
                  centerButton(
                      Constants.height / 14,
                      Constants.width * 0.50,
                      Constants.width * 0.10,
                      ColorConstants.primaryColor,
                      ColorConstants.blackColor,
                      "Save",
                      Save,
                      context),



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
  String getRandom(int length){
    const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    Random r = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
  }

  Future getImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      uploadingImage = true;
    });
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child(getRandom(15));

    UploadTask uploadTask =
    storageReference.putFile(File(pickedFile!.path.toString()));



    //
    await uploadTask.then((taskSnapshot) async {
      uploadedFileURL = await taskSnapshot.ref.getDownloadURL();
      showSnackBar("Successfully uploaded profile picture");
    }).catchError((e) {
      showSnackBar("Failed to upload profile picture");
    });

    setState(() {
      uploadingImage = false;
    });
  }
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  // SaveProfile() async {
  //   FirebaseAuth.instance
  //       .createUserWithEmailAndPassword(
  //     email: emailController.text.trim(),
  //     password: passwordController.text,
  //   )
  //       .then((value) async {
  //     Constants.loggedInUserID = FirebaseAuth.instance.currentUser!.uid;
  //     User? user = value.user;
  //
  //     await user!.updateProfile(
  //       displayName: fullNameController.text,
  //       photoURL: uploadedFileURL,
  //     );
  //
  //     String u="";
  //     if(_userType==UserType.PARENT)
  //     {
  //       u="PARENT";
  //     }
  //     else
  //     {
  //       u="DRIVER";
  //     }
  //
  //
  //     String g="";
  //     if(gender==Gender.male)
  //     {
  //       g="male";
  //     }
  //     else
  //     {
  //       u="female";
  //     }
  //
  //     await UserRepository().createUser(
  //       UserModel(
  //           Constants.loggedInUserID,
  //           emailController.text,
  //           fullNameController.text,
  //           addressController.text,
  //           uploadedFileURL,
  //           phoneNoController.text,
  //           u,
  //           "",
  //           g,
  //           lattitude.toString(),
  //           longitude.toString(),
  //           selectedSchool
  //       ),
  //     );
  //
  //     uploadedFileURL="";
      // emailController.text = "";
      // fullNameController.text = "";
      // addressController.text = "";
      // phoneNoController.text = "";


      // showSnackBar("Changes have been updated successfully");
    //
    // }).catchError((e) {
    //   showSnackBar(e.message);
    // });
  // }

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
     //showSnackBar("${p.description} - $lat/$lng");

    // displayPrediction(p!, homeScaffoldKey.currentState!);
  }
}
