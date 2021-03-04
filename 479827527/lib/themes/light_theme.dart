import 'package:flutter/material.dart';

ThemeData lightThemeData = ThemeData(
  primarySwatch: Colors.deepPurple,
  accentColor: Colors.deepPurple,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: Colors.white,
    backgroundColor: Color.fromRGBO(30, 144, 255, 100),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.deepPurple,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
  ),
  appBarTheme: AppBarTheme(
    color: Colors.deepPurple,
    centerTitle: true,
  ),
);
