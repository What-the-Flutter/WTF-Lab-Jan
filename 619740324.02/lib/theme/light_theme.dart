import 'package:flutter/material.dart';

ThemeData lightThemeData = ThemeData(
  backgroundColor: Colors.deepPurple,
  primarySwatch: Colors.deepPurple,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  iconTheme: const IconThemeData(
    color: Colors.deepPurple,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: Colors.white,
    backgroundColor: Colors.deepPurple,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.deepPurple,
    centerTitle: true,
  ),
);
