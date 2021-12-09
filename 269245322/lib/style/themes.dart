import 'package:flutter/material.dart';

enum MyThemeKeys { light, dark }

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.pink,
    toggleButtonsTheme: ToggleButtonsThemeData(
      color: Colors.yellow,
      selectedColor: Colors.grey[350],
      disabledColor: Colors.grey,
      fillColor: Colors.black,
    ),
    primaryColorLight: Colors.black,
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.grey,
    toggleButtonsTheme: ToggleButtonsThemeData(
      color: Colors.black,
      selectedColor: Colors.grey,
      disabledColor: Colors.grey[350],
      fillColor: Colors.yellow,
    ),
    brightness: Brightness.dark,
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.light:
        return lightTheme;
      case MyThemeKeys.dark:
        return darkTheme;
      default:
        return lightTheme;
    }
  }
}
