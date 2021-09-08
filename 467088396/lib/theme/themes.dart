import 'package:flutter/material.dart';

import '../constants.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColor,
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      color: textColor,
    ),
    bodyText2: TextStyle(
      color: textColor,
    ),
    caption: TextStyle(
      color: Colors.black,
    ),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: secondColor,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    unselectedItemColor: primaryColor.withOpacity(0.6),
    selectedItemColor: primaryColor,
  ),
  cardColor: Colors.white,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xff545FAB),
  scaffoldBackgroundColor: const Color(0xff707797),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      color: Colors.white,
    ),
    bodyText2: TextStyle(
      color: Colors.white,
    ),
    caption: TextStyle(
      color: Colors.white,
    ),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xff545FAB),
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xff545FAB),
    unselectedItemColor: Colors.white60,
    selectedItemColor: Colors.white,
  ),
  cardColor: const Color(0xff626986),
);