import 'package:flutter/material.dart';

class ConfigProvider
    extends ChangeNotifier {

  String currentlanguage = "en";

  bool get isEnglishEnabled =>
      currentlanguage == "en";

  void changeLanguage(
      String newlanguage) {

    if (currentlanguage ==
        newlanguage) {
      return;
    }

    currentlanguage =
        newlanguage;

    notifyListeners();
  }
}