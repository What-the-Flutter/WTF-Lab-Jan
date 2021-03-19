import 'package:flutter/material.dart';

ThemeData darkThemeData = ThemeData(
  brightness: Brightness.dark,
  accentColor: Colors.yellow,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.yellow,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.yellow,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
  ),
);