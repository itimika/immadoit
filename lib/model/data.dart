import 'package:flutter/material.dart';

class Data with ChangeNotifier{
  TextEditingController controller = TextEditingController();
  bool timerFrag = false;

  void clear() {
    controller.clear();
    notifyListeners();
  }

  void updateFrag() {
    timerFrag = !timerFrag;
    notifyListeners();
  }
}