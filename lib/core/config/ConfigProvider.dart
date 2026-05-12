import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigProvider extends ChangeNotifier {
  static const _langKey = 'app_language';

  String currentlanguage = 'en';

  ConfigProvider() {
    _loadLanguage();
  }

  bool get isEnglishEnabled => currentlanguage == 'en';

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_langKey);
    if (saved != null && saved != currentlanguage) {
      currentlanguage = saved;
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String newLanguage) async {
    if (currentlanguage == newLanguage) return;
    currentlanguage = newLanguage;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, newLanguage);
    notifyListeners();
  }
}
