import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:school_bus_transit/common/colorConstants.dart';
import 'package:school_bus_transit/view/splash.dart';
import 'package:material_color_gen/material_color_gen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp( MyApp());
}


class MyApp extends StatelessWidget {

  Color theamecolor=ColorConstants.primaryColor;

   MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: theamecolor,
        primarySwatch: theamecolor.toMaterialColor(),
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: theamecolor
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

