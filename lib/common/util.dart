import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Util{

  static int getRandomNumber(min, max)
  {
      return min + Random().nextInt(max - min);
  }

  static Future<String> makingPhoneCall(String number) async {
    var url = Uri.parse("tel:+1 $number");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      return 'Could not launch $url';
    }
    return "success";
  }

}


class Bouncing extends StatefulWidget {
  final Widget child;
  final VoidCallback onPress;

  Bouncing({Key? key,required this.child, required this.onPress}): assert(child != null),
        super(key: key);

  @override
  _BouncingState createState() => _BouncingState();
}

class _BouncingState extends State<Bouncing>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        if (widget.onPress != null) {
          _controller.forward();
        }
      },
      onPointerUp: (PointerUpEvent event) {
        if (widget.onPress != null) {
          _controller.reverse();
          widget.onPress();
        }
      },
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}