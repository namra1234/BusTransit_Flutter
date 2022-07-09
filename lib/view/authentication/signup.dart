import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:school_bus_transit/common/buttonStyle.dart';
import 'package:school_bus_transit/common/colorConstants.dart';
import 'package:school_bus_transit/common/constants.dart';
import 'package:school_bus_transit/model/userModel.dart';
import 'package:school_bus_transit/repository/userRep.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multiselect/multiselect.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:map_address_picker/map_address_picker.dart';
import 'package:map_address_picker/models/location_result.dart';
// import 'package:geocoder/geocoder.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

enum UserType { parents, driver }
enum Gender { male, female }

class _SignupScreenState extends State<SignupScreen> {

  List<String> allschool = ['Cegep Gim','ISI','Concordia','Lasaale'];
  List<String> selectedSchool = [];
  bool uploadingImage=false;
  String uploadedFileURL = "";

  String name = "";
  bool changeButton = false;
  late TextEditingController emailController,
      passwordController,
      fullNameController,
      addressController,
      postalCodeController,
      phoneNoController,
      confirmPasswordController;

  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormFieldState> _multiSelectKey = new GlobalKey<FormFieldState>();
  UserType? _userType = UserType.parents;
  Gender? gender = Gender.male;
  final Geolocator geolocator = Geolocator();

  register() async {
    if (_formKey.currentState!.validate()) {

      if(selectedSchool.length==0 && _userType==UserType.parents)
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
          singUp();
        }


    }
  }

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();
    fullNameController = TextEditingController();
    addressController = TextEditingController();
    postalCodeController = TextEditingController();
    phoneNoController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    addressController.dispose();
    postalCodeController.dispose();
    phoneNoController.dispose();
    confirmPasswordController.dispose();
  }

  LocationResult? locationResult;
  _openLocationPicker() async {
    var _result = await showLocationPicker(
      context,
      mapType: MapType.terrain,
      requiredGPS: true,
      automaticallyAnimateToCurrentLocation: true,
      initialCenter: LatLng(45.555667, -73.668274),
      desiredAccuracy: LocationAccuracy.best,
      title: "Pick your location",
      layersButtonEnabled: true,
      initialZoom: 16,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );

    if (mounted) setState(() => locationResult = _result);

    // locationResult!.latLng!.latitude;


  }

  @override
  Widget build(BuildContext context) {
    Constants.height = MediaQuery.of(context).size.height;
    Constants.width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: SafeArea(
        child: Stack(
          children: [

            //debugShowCheckedModeBanner="false";
            SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.only(top:Constants.height/15,left:Constants.width/18,right:Constants.width/18),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              "assets/images/second_logo.png",
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Registration",
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

                                  )),
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
                                    TextFormField(
                                      controller: addressController,
                                      decoration:  InputDecoration(
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        hintText: "Address",
                                        labelText: "Enter Address",
                                        suffixIcon:  InkWell(
                                          onTap: _openLocationPicker,
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
                                    TextFormField(
                                      controller: phoneNoController,
                                      decoration: const InputDecoration(
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        hintText: "Phone No",
                                        labelText: "Enter Phone No",
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Field can not be empty";
                                        }

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
                                          Container(
                                            width:Constants.width/3.25,
                                            child: Expanded(
                                                child: RadioListTile<UserType>(
                                                  contentPadding: EdgeInsets.only( // Add this
                                                      left: 0,
                                                      right: 0,
                                                      bottom: 0,
                                                      top: 0
                                                  ),
                                                  title:  Align(
                                                      alignment: Alignment(-4.1, 0),
                                                      child: Text('Parents')),
                                                  value: UserType.parents,
                                                  groupValue: _userType,
                                                  onChanged: (UserType? value) {
                                                    setState(() {
                                                      _userType = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                          ),
                                          Expanded(
                                              child: RadioListTile<UserType>(
                                                contentPadding: EdgeInsets.only( // Add this
                                                    left: 0,
                                                    right: 0,
                                                    bottom: 0,
                                                    top: 0
                                                ),
                                                title:  Align(
                                                    alignment: Alignment(-1.3, 0),
                                                    child: Text('Driver')),
                                                value: UserType.driver,
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
                                    UserType.parents == _userType ? DropDownMultiSelect(
                                      onChanged: (List<String> x) {
                                        setState(() {
                                          selectedSchool =x;
                                        });
                                      },
                                      options: allschool,
                                      selectedValues: selectedSchool,
                                      whenEmpty: 'Select School',
                                    ): Container(),
                                    TextFormField(
                                      controller: passwordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        labelStyle:
                                        TextStyle(color: Colors.black),
                                        hintText: "Password",
                                        labelText: "Enter Password",
                                      ),
                                      validator: (value) {
                                        String passwordPattern =
                                            '((?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#\$%^&+=])(?=\\S+).{4,})';
                                        RegExp regExp =
                                        RegExp(passwordPattern);
                                        if (value!.isEmpty) {
                                          return "Field can not be empty";
                                        } else if (!regExp
                                            .hasMatch(value)) {
                                          return "Password is too weak";
                                        }

                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      controller: confirmPasswordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        labelStyle:
                                        TextStyle(color: Colors.black),
                                        hintText: "Confirm Password",
                                        labelText: "Enter Confirm Password",
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Field can not be empty";
                                        } else if (value !=
                                            passwordController.text) {
                                          return "Confirm password must match password";
                                        }

                                        return null;
                                      },
                                    ),
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
                        "Sign Up",
                        register,
                        context),
                    SizedBox(height: 30.0),
                    Padding(
                      padding:  EdgeInsets.only(left:18.0,right:18.0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                  fontSize: 17, color: Colors.black.withOpacity(0.5)),
                            ),
                            InkWell(
                              onTap: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //         const LoginScreen()));
                              },
                              child: Container(
                                child: Text('Sign in',
                                    style: TextStyle(
                                        color: ColorConstants.blackColor,
                                        fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30),
                  ],
                ),
              ),
            )
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




    // uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
    //   switch (taskSnapshot.state) {
    //     case TaskState.running:
    //       final progress =
    //           100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
    //       print("Upload is $progress% complete.");
    //       break;
    //     case TaskState.paused:
    //       print("Upload is paused.");
    //       break;
    //     case TaskState.canceled:
    //       print("Upload was canceled");
    //       break;
    //     case TaskState.error:
    //       print(TaskState.error);
    //     // Handle unsuccessful uploads
    //       break;
    //     case TaskState.success:
    //     // Handle successful uploads on complete
    //     // ...
    //       break;
    //   }
    // });




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

  singUp() async {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text,
    )
        .then((value) async {
      Constants.loggedInUserID = FirebaseAuth.instance.currentUser!.uid;
      User? user = value.user;

      await user!.updateProfile(
        displayName: fullNameController.text,
        photoURL: uploadedFileURL,
      );

      String u="";
      if(_userType==UserType.parents)
        {
          u="driver";
        }
      else
        {
          u="parents";
        }


      String g="";
      if(gender==Gender.male)
      {
        g="male";
      }
      else
      {
        u="female";
      }

      await UserRepository().createUser(
        UserModel(
            Constants.loggedInUserID,
            emailController.text,
            fullNameController.text,
            addressController.text,
            uploadedFileURL,
            phoneNoController.text,
            u,
            "",
            g,
            "",
            "",
            selectedSchool
        ),
      );



      // uploadedFileURL="";
      emailController.text = "";
      passwordController.text = "";
      fullNameController.text = "";
      addressController.text = "";
      phoneNoController.text = "";
      confirmPasswordController.text = "";

      showSnackBar("Account has been created Successfully");

    }).catchError((e) {
      showSnackBar(e.message);
    });
  }
}
