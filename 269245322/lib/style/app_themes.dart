import 'package:flutter/material.dart';

enum AppTheme {
  blueLight,
  blueDark,
}

final appThemeData = {
  AppTheme.blueLight: ThemeData(
    brightness: Brightness.light,
    backgroundColor: Colors.blue[50],
    primaryColor: Colors.blue,
    primaryColorLight: Colors.white,
    primaryColorDark: Colors.grey[900],
    secondaryHeaderColor: Colors.black,
    colorScheme: const ColorScheme(
      primary: Colors.blue,
      onPrimary: Colors.white,
      primaryVariant: Colors.black,
      secondary: Color.fromRGBO(70, 70, 70, 0.8),
      onSecondary: Colors.black,
      secondaryVariant: Color.fromRGBO(0, 77, 255, 0.8),
      background: Colors.black,
      onBackground: Colors.white,
      surface: Colors.black,
      onSurface: Colors.black,
      brightness: Brightness.light,
      error: Colors.red,
      onError: Colors.redAccent,
    ),
    cardColor: Colors.blue[100],
    primaryIconTheme: IconThemeData(color: Colors.blue[900]),
    iconTheme: IconThemeData(color: Colors.blue[700]),
    indicatorColor: Colors.blue[100],
    dividerColor: Colors.blue,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
  ),
  AppTheme.blueDark: ThemeData(
    brightness: Brightness.dark,
    backgroundColor: Colors.grey[900],
    primaryColor: Colors.grey[900],
    primaryColorLight: Colors.white,
    primaryColorDark: Colors.yellow[400],
    secondaryHeaderColor: Colors.yellow,
    cardColor: Colors.grey[900],
    primaryIconTheme: IconThemeData(color: Colors.yellow[900]),
    iconTheme: IconThemeData(color: Colors.yellow[700]),
    indicatorColor: Colors.yellow[700],
    dividerColor: Colors.yellow,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.yellow[700],
      foregroundColor: Colors.black,
    ),
  ),
};
