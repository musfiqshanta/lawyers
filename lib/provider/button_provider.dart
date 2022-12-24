import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  // get count => null;

  //int _count = 0;

  dynamic button;

  dynamic get getdata => button;

  void increment(String at) {
    button = at;
    notifyListeners();
  }
}
