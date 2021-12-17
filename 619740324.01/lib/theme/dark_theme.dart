import 'package:flutter/material.dart';

ThemeData darkThemeData = ThemeData(
  backgroundColor: Colors.black,
  brightness: Brightness.dark,
  iconTheme: const IconThemeData(
    color: Colors.yellow,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.yellow,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.yellow,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
  ),
);
