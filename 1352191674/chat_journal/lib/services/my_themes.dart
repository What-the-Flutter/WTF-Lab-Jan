import 'package:flutter/material.dart';

enum MyThemeKeys {
  light,
  dark,
}

final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blueGrey,
    brightness: Brightness.light,
  );

final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
  );
