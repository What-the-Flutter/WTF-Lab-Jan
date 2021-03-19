import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';

SharedPreferences _themePreferences;
const _keyTheme = 'theme';

Future initThemePreferences() async =>
    _themePreferences = await SharedPreferences.getInstance();

Future changeThemePreferences(bool isOnPressed) async =>
    await _themePreferences.setBool(_keyTheme, isOnPressed);

ThemeData getCurrentThemePreferences() {
  var isCurrentThemeDark = _themePreferences.getBool(_keyTheme) ?? false;
  return isCurrentThemeDark == true ? darkTheme : lightTheme;
}
