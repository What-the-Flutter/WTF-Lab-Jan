import 'package:flutter/material.dart';

enum MyThemeKeys {
  light,
  dark,
}

// ignore: avoid_classes_with_only_static_members
class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: HexColor('#ffa45c'),
    accentColor: HexColor('#ffcdab'),
    cardColor: HexColor('#ffcdab'),
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.black,
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

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
