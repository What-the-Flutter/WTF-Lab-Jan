import 'package:flutter/material.dart';

enum CustomThemeKeys {
  light,
  dark,
}

// ignore: avoid_classes_with_only_static_members
class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: pinkDecor,
    accentColor: blue,
    brightness: Brightness.light,
    backgroundColor: pinkBg,
    primaryColorLight: itemPageLight,
    textSelectionColor: blue,
    unselectedWidgetColor: black,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: darkDecor,
    backgroundColor: darkBg,
    accentColor: yellow,
    brightness: Brightness.dark,
    primaryColorLight: itemPageDark,
    textSelectionColor: yellow,
    unselectedWidgetColor: white,
  );

  static ThemeData getThemeFromKey(CustomThemeKeys themeKey) {
    switch (themeKey) {
      case CustomThemeKeys.light:
        return lightTheme;
      case CustomThemeKeys.dark:
        return darkTheme;
      default:
        return lightTheme;
    }
  }
}

const white = Colors.white;
const black = Colors.black;
const appBarText = Color(0xFFBDC3C6);

// light theme

const pinkBg = Color(0xFFFBF2F2);
const pinkDecor = Color(0xFFFCE8E8);
const blue = Color(0xFF81D9F4);
Color itemPageLight = const Color(0xFFFEDB81).withOpacity(0.3);
const themeIconLight = Color(0xFFFFA979);

// dark theme
const yellow = Color(0xFFF9F6BF);
const themeIconDark = Color(0xFFFFFFFF);
Color itemPageDark = const Color(0xFF121053).withOpacity(0.6);
const darkBg = Color(0xFF7A7D7D);
const darkDecor = Color(0xFF42416D);
const shadowColor = Colors.black54;
