import 'package:flutter/material.dart';

enum AppTheme {
  blueLight,
  blueDark,
}

final appThemeData = {
  AppTheme.blueLight: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
  ),
  AppTheme.blueDark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[900],
  ),
};
