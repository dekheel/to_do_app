import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfigProvider extends ChangeNotifier {
  // config section
  String appLanguage = "en";
  String userEmail = "";

  ThemeMode appTheme = ThemeMode.light;

  final bool isDarkTheme;
  final bool isEnglish;

  AppConfigProvider(this.isDarkTheme, this.isEnglish) {
    if (isDarkTheme) {
      appTheme = ThemeMode.dark;
    }
    if (!isEnglish) {
      appLanguage = "ar";
    }
  }

  changeLanguage(String newLanguage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (newLanguage == appLanguage) {
      if (newLanguage == "en") {
        prefs.setBool("isEnglish", true);
      } else {
        prefs.setBool("isEnglish", false);
      }

      return;
    }

    if (newLanguage == "en") {
      prefs.setBool("isEnglish", true);
    } else {
      prefs.setBool("isEnglish", false);
    }
    appLanguage = newLanguage;

    notifyListeners();
  }

  Future<void> changeTheme(ThemeMode newTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (newTheme == appTheme) {
      if (newTheme == ThemeMode.dark) {
        prefs.setBool("isDark", true);
      } else {
        prefs.setBool("isDark", false);
      }

      return;
    }

    if (newTheme == ThemeMode.dark) {
      prefs.setBool("isDark", true);
    } else {
      prefs.setBool("isDark", false);
    }

    appTheme = newTheme;

    notifyListeners();
  }

  bool isDarkMode() {
    return appTheme == ThemeMode.dark;
  }

  bool isArLang() {
    return appLanguage == "ar";
  }

  // tasks section

  changeEmail(String newEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (userEmail != newEmail) {
      prefs.setString("userEmail", newEmail);
      return;
    }
    notifyListeners();
  }
}
