import 'package:school_bus_transit/model/parentScreenModel.dart';
import 'package:school_bus_transit/model/userModel.dart';

import '../model/busModel.dart';
import '../model/schoolModel.dart';

class Constants {

  static int SPLASH_SCREEN_TIME = 2;
  static double height = 0, width = 0;
  static final String API_KEY = "AIzaSyAgpLONoQLPhvXWh05qs8cCBdmZS9NDolw";
  static String loggedInUserID = "";
  static UserModel userdata = new UserModel('', '', '', '', '', '', '', '', '', '', '', []);
  static List<UserModel> driverdataTemp = [];
  static List<parentScreenModel> parentScreenData = [];
  static List<SchoolModel> schoolList=[];
  static List<BusModel> busList=[];

  static BusModel singleBusData = new BusModel("", 0, "", false, false, "", "", "", "", "", "", "", "");

  static UserModel CurrentDriverdata = new UserModel('', '', '', '', '', '', '', '', '', '', '', []);

  static List<UserModel> driverList = [new UserModel('', '', '', '', '', '', '', '', '', '', '', [])];

  static void CurrentDriverData_reset(){
    CurrentDriverdata = new UserModel('', '', '', '', '', '', '', '', '', '', '', []);
  }

}

class validationMsg {
  static String emailNotEnter = 'Enter email';
  static String noInternet = 'Please connect to the internet to continue.';
}


