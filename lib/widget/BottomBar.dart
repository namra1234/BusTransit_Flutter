import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';

import '../common/colorConstants.dart';

Widget BottomBar(dynamic pressEvent(int) , int currentIndex)
{
  return BubbleBottomBar(
    hasNotch: true,
    fabLocation: BubbleBottomBarFabLocation.end,
    opacity: .2,
    currentIndex: currentIndex,
    // onTap: pressEvent,
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(16),
    ), //border radius doesn't work when the notch is enabled.
    elevation: 8,
    tilesPadding: EdgeInsets.symmetric(
      vertical: 8.0,
    ),
    items: <BubbleBottomBarItem>[
      BubbleBottomBarItem(
          backgroundColor: ColorConstants.primaryColor,
          icon: Icon(
            Icons.notifications,
            color: ColorConstants.customGreyColor,
          ),
          activeIcon: Icon(
            Icons.notifications,
            color: Colors.black,
          ),
          title: Text("Notifications")),
      BubbleBottomBarItem(
          backgroundColor: ColorConstants.primaryColor,
          icon: Icon(
            Icons.home,
            color: ColorConstants.customGreyColor,
          ),
          activeIcon: Icon(
            Icons.home,
            color: Colors.black,
          ),
          title: Text("Home")),
      BubbleBottomBarItem(
          backgroundColor: ColorConstants.primaryColor,
          icon: Icon(
            Icons.person,
            color: ColorConstants.customGreyColor,
          ),
          activeIcon: Icon(
            Icons.person,
            color: Colors.black,
          ),
          title: Text("Profile"))
    ],
  );
}