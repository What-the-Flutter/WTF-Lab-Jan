import 'package:flutter/material.dart';

import 'theme.dart';
import 'theme_preferences.dart';

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme = getCurrentThemePreferences();
  bool isDark;

  void changeTheme() {
    currentTheme = getCurrentThemePreferences();
    isDark = currentTheme == lightTheme ? true : false;
    changeThemePreferences(isDark);
    currentTheme = isDark ? darkTheme : lightTheme;
    return notifyListeners();
  }
}
