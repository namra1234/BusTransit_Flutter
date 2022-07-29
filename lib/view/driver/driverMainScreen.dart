import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import './driverNotification.dart';

import '../../common/colorConstants.dart';

class DriverMainPage extends StatefulWidget {
  @override
  _DriverMainPageState createState() => _DriverMainPageState();
}

class _DriverMainPageState extends State<DriverMainPage>
    with WidgetsBindingObserver {
  late int currentIndex;
  @override
  void initState() {
    currentIndex = 1;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  changePage(int? index) {
    setState(() {
      currentIndex = index!;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: BottomBar(),
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryColor,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text("Welcome John"),
            )
          ],
        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: currentIndex == 1
          ? Column(
              children: [
                Expanded(
                    child: Container(
                  child: Text('Home Page'),
                ))
              ],
            )
          : currentIndex == 0 ? DriverNotification()
          : Column(
            children: [
              Expanded(
                  child: Container(
                    child: Text('Profile'),
                  ))
            ],
        ),
    );
  }

  Widget BottomBar() {
    return BubbleBottomBar(
      hasNotch: true,
      opacity: 0.2,
      currentIndex: currentIndex,
      onTap: changePage,
      backgroundColor: ColorConstants.primaryColor,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ), //border radius doesn't work when the notch is enabled.
      elevation: 8,
      tilesPadding: EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      items: <BubbleBottomBarItem>[
        BubbleBottomBarItem(
            backgroundColor: Colors.black,
            icon: Icon(
              Icons.notifications,
              color: ColorConstants.bottomBarIconColor,
            ),
            activeIcon: Icon(
              Icons.notifications,
              color: Colors.black,
            ),
            title: Text("Notifications")),
        BubbleBottomBarItem(
            backgroundColor: Colors.black,
            icon: Icon(
              Icons.home,
              color: ColorConstants.bottomBarIconColor,
            ),
            activeIcon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: Text("Home"),
        ),
        BubbleBottomBarItem(
            backgroundColor: Colors.black,
            icon: Icon(
              Icons.person,
              color: ColorConstants.bottomBarIconColor,
            ),
            activeIcon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            title: Text("Profile"))
      ],
    );
  }
}
