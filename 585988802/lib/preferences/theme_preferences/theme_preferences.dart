import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences _themePreferences;
const _keyThemeMode = 'themeMode';

Future initThemePreferences() async =>
    _themePreferences = await SharedPreferences.getInstance();

Future changeThemePreferences(bool isOnPressed) async =>
    await _themePreferences.setBool(_keyThemeMode, isOnPressed);

ThemeMode getCurrentThemeModePreferences() {
  var isCurrentThemeModeDark =
      _themePreferences.getBool(_keyThemeMode) ?? false;
  return isCurrentThemeModeDark == true ? ThemeMode.dark : ThemeMode.light;
}
