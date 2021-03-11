import 'package:flutter/material.dart';
import 'theme.dart';

enum ThemeType { light, dark }

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme = lightTheme;
  ThemeType _themeType = ThemeType.light;

  void changeTheme() {
    if (_themeType == ThemeType.dark) {
      currentTheme = lightTheme;
      _themeType = ThemeType.light;
      return notifyListeners();
    }

    if (_themeType == ThemeType.light) {
      currentTheme = darkTheme;
      _themeType = ThemeType.dark;
      return notifyListeners();
    }
  }
}
