import 'dart:ui';

import 'package:flutter/material.dart';

class CustomTextStyle
{

 static TextStyle splashWelcome(double size,double height,double width, Color textcolor)
  {
    return TextStyle(
    fontFamily: 'DM Sans',
    fontSize: (size==null && size=='')? 36 : (width*size)/375,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    color: textcolor,
    // lineHeight: 47px,
    letterSpacing: -0.01,
  );
  }


  static TextStyle heading(double size,double height,double width)
  {
    return TextStyle(
    fontFamily: 'DM Sans',
    fontSize: (size==null && size=='')? 48 : (width*size)/375,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    // lineHeight: 47px,
    letterSpacing: -0.01,
  );
  }

  
 static TextStyle buttonText(double size,double height,double width)
  {
    return TextStyle(
    fontFamily: 'DM Sans',
    fontSize: (size==null && size=='')? 14 : (width*size)/375,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    // lineHeight: 47px,
    letterSpacing: -0.01,
  );
  }


  static TextStyle mediumText(double size,double width)
  {
    return TextStyle(
    fontFamily: 'DM Sans',
    fontSize: (size==null && size=='')? 24 : (width*size)/375,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w900,
    // lineHeight: 47px,
    letterSpacing: -0.01,
  );
  }


 static TextStyle regularText(double size,double width)
 {
   return TextStyle(
     fontFamily: 'DM Sans',
     fontSize: (size==null && size=='')? 24 : (width*size)/375,
     fontStyle: FontStyle.normal,
     fontWeight: FontWeight.w600,
     color: Colors.black.withOpacity(0.5),
     letterSpacing: -0.01,
   );
 }


}
 