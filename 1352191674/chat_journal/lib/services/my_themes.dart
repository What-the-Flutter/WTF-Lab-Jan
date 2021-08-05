import 'package:flutter/material.dart';

enum MyThemeKeys {
  light,
  dark,
}

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blueGrey,
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
  );
}