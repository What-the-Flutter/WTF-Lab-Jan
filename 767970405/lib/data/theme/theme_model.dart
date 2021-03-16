import 'package:flutter/material.dart';
import 'theme.dart';

enum ThemeType { light, dark }

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme = lightTheme;
  ThemeType themeType = ThemeType.light;

  ThemeModel({int index}) {
    if (index != null) {
      themeType = ThemeType.values[index];
      currentTheme = index == 0 ? lightTheme : darkTheme;
    }
  }

  void toggleTheme() {
    if (themeType == ThemeType.dark) {
      currentTheme = lightTheme;
      themeType = ThemeType.light;
      return notifyListeners();
    }

    if (themeType == ThemeType.light) {
      currentTheme = darkTheme;
      themeType = ThemeType.dark;
      return notifyListeners();
    }
  }
}
