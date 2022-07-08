import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'textStyle.dart';

Widget centerButton(double height,double width,double fontsize,Color buttonColor,Color textColor, String buttonText,VoidCallback pressEvent,BuildContext context)
{
  return Container(
              width: width,
              height: height,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    ),
                onPressed: pressEvent,
                padding: EdgeInsets.all(10.0),
                color: buttonColor,
                textColor: textColor,
                child: Center(
                  child: Text(buttonText,
                      style: CustomTextStyle.buttonText(fontsize,height,width)),
                ),
              ),
            );
}
