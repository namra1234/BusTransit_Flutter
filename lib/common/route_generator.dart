
import 'package:flutter/material.dart';

const String PreSelectes = 'preselect';
const String MainDashboardScreen = 'mainDashboard';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String,dynamic>;
    Widget page=Text('');
    switch (settings.name) {
      case PreSelectes:
        // page = PreSelect();
        break;
      case MainDashboardScreen:
        // page = MainDashboard();
        break;
     
      default:
        // page = PreSelect();
        break;
    }
    return MaterialPageRoute(builder: (context) => page,);
  }
}
