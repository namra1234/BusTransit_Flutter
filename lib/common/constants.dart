import 'package:school_bus_transit/model/userModel.dart';

import '../model/schoolModel.dart';

class Constants {

  static int SPLASH_SCREEN_TIME = 2;
  static double height = 0, width = 0;
  static String loggedInUserID = "";
  static UserModel userdata = new UserModel('', '', '', '', '', '', '', '', '', '', '', []);
  static List<SchoolModel> schoolList=[];

}

class validationMsg {
  static String emailNotEnter = 'Enter email';
  static String noInternet = 'Please connect to the internet to continue.';
}


