
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
class alertOpen{
 static showAlertOnebtn({BuildContext? context,String? title,String? message,String? btnTitle}) {
  
  clickbtn()
  {
    Navigator.pop(context!);
    if(message=='Password changed successfully.') {
      Navigator.pop(context);
    }
    else if(message=='User profile updated successfully'){
      Navigator.pop(context);
    }
  }

   Widget okButton = FlatButton(
     child: Text(btnTitle!),
     onPressed: () {
       clickbtn();
       },
   );

   // set up the AlertDialog
   AlertDialog alert = AlertDialog(
     title: Text(title!),
     content: Text(message!),
     actions: [
       okButton,
     ],
   );

   // show the dialog

   showDialog(
     context: context!,
     builder: (BuildContext context) {
       return alert;
     },
   );


  }
}