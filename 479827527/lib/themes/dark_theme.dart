import 'package:flutter/material.dart';

ThemeData darkThemeData = ThemeData(
  brightness: Brightness.dark,
  accentColor: Colors.orangeAccent,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.orangeAccent,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.orangeAccent,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
  ),
);
