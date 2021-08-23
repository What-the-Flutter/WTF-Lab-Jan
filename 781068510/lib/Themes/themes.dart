import 'package:flutter/material.dart';

class Themes {
  final ThemeData lightTheme = ThemeData(
    backgroundColor: const Color(0xffFFC107),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color(0xff512DA8),
      unselectedItemColor: Color(0xff000000),
    ),
    scaffoldBackgroundColor: const Color(0xffFFFFFF),
    primaryColor: const Color(0xffFFFFFF),
    accentColor: const Color(0xff512DA8),
    primaryColorLight: const Color(0xff512DA8).withAlpha(50),
  );

  final ThemeData darkTheme = ThemeData.dark();

  final ThemeData testDarkTheme = ThemeData(
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    textTheme: Typography.whiteMountainView,
    backgroundColor: const Color(0xff949929),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xff262823),
      selectedItemColor: Color(0xffFFa48e),
      unselectedItemColor: Color(0xffFFFFFF),
    ),
    scaffoldBackgroundColor: const Color(0xff262823),
    primaryColor: const Color(0xffFFa48e),
    accentColor: const Color(0xffFFa48e),
    primaryColorLight: const Color(0xffFFa48e),
    appBarTheme: const AppBarTheme(
      color: Color(0xff262823),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
  );
}
