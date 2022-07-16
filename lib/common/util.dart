import 'dart:math';

import 'package:flutter/material.dart';

class Util{

  static int getRandomNumber(min, max)
  {
      return min + Random().nextInt(max - min);
  }

}