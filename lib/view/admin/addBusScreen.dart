import 'package:flutter/material.dart';
import 'package:school_bus_transit/model/busModel.dart';
import 'package:school_bus_transit/model/schoolModel.dart';
import 'package:school_bus_transit/repository/schoolRep.dart';

import '../../common/buttonStyle.dart';
import '../../common/colorConstants.dart';

import 'package:geolocator/geolocator.dart';
import 'package:map_address_picker/models/location_result.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';

import 'package:school_bus_transit/common/constants.dart';
import '../../common/util.dart';
import '../../repository/busRep.dart';

const kGoogleApiKey = "AIzaSyAgpLONoQLPhvXWh05qs8cCBdmZS9NDolw";
final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();


// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class AddBusScreen extends StatefulWidget{

  SchoolModel school_;
  AddBusScreen({Key? key, required this.school_}) : super(key: key);

  @override
  _AddBusScreenState createState() => _AddBusScreenState();

}

class _AddBusScreenState extends State<AddBusScreen>{

  double latitude = 0;
  double longitude = 0;
  int busCount = 0;

  late TextEditingController busNumberController, addressController;



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
    busNumberController = TextEditingController();
    addressController = TextEditingController();
    getBusCount();

  }

  @override
  void dispose() {
    super.dispose();
    busNumberController.dispose();
    addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("School Section",textAlign: TextAlign.center,
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
    return Container(child: Text("· New Bus ·",style: TextStyle(fontSize: 40,)),margin: const EdgeInsets.all(20),);
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
                        controller: busNumberController,
                        enabled: false,
                        style: TextStyle(fontSize: 40),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelStyle:
                          TextStyle(color: Colors.black),
                          hintText: "Bus Number",
                          labelText: "Bus Number",
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
                      InkWell(
                        onTap: _handlePressButton,
                        child: TextFormField(
                          readOnly: true,
                          controller: addressController,
                          decoration:  InputDecoration(
                            labelStyle:
                            const TextStyle(color: Colors.black),
                            hintText: "Address",
                            labelText: "Find Last Stop of bus",
                            suffixIcon:  InkWell(
                              onTap: _handlePressButton,
                              child: const Icon(
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

    BusModel newModel = BusModel(
      "No Bus Id",
      int.parse(busNumberController.text),
      widget.school_.school_id,
      false,
      false,
      "45.4947001",
      "-73.6238721",
      widget.school_.address,
      widget.school_.lat,
      widget.school_.long,
      addressController.text.toString(),
      latitude.toString(),
      longitude.toString()
    );

    String newBusId = await BusRepository().addNewBus(
        newModel.toJson());

    if(newBusId == "false")
    {
      showSnackBar("Error : There is something wrong!");
      return;
    }

    newModel.bus_id = newBusId;
    await BusRepository().updateBus(
        newModel.toJson(),newBusId);

    getBusCount();
    addressController.clear();

    showSnackBar("Bus has been added Successfully");

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

    latitude = lat;
    longitude =lng;
    addressController.text = p.description!;
    // showSnackBar("${p.description} - $lat/$lng");

    // displayPrediction(p!, homeScaffoldKey.currentState!);
  }

  getBusCount() async {
    busCount = await BusRepository().BusCount();
    busNumberController.text = ((Util.getRandomNumber(2,9)*100)+busCount).toString();
    setState(() {});
  }

}