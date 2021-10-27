import 'package:flutter/material.dart';

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.white,
    cardColor: Colors.pink.shade100,
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        fontFamily: 'Merriweather',
        fontSize: 16.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      caption: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.purple.shade900,
        secondaryVariant: Colors.grey.shade700),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.black,
    cardColor: Colors.grey.shade900,
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        fontFamily: 'Merriweather',
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 0.5,
      ),
      caption: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.purple.shade900, secondaryVariant: Colors.white),
  );

  static ThemeData getThemeFromMode(CustomThemeMode themeMode) {
    switch (themeMode) {
      case CustomThemeMode.light:
        return lightTheme;
      case CustomThemeMode.dark:
        return darkTheme;
      default:
        return lightTheme;
    }
  }
}

enum CustomThemeMode {
  light,
  dark,
}

const themeIconLight = Color(0xFFFFA979);
const themeIconDark = Color(0xFFFFFFFF);
const floatingButtonColor = Color(0XFFEDA900);
