import 'package:flutter/material.dart';

class Themes {

  final lightTheme = ThemeData(
    backgroundColor: Colors.yellowAccent,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.black),
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    accentColor: Colors.deepPurple,
    primaryColorLight: Colors.deepPurple[100],
  );

  final darkTheme = ThemeData.dark();

}