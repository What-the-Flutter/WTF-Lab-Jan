import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.yellow,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.yellow,
    unselectedItemColor: Colors.white60,
  ),
  iconTheme: IconThemeData(
    color: Colors.yellow,
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusColor: Colors.yellow,
  )

);