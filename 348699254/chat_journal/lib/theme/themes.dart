import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.teal,
  iconTheme: const IconThemeData(
    color: Colors.teal,
  ),
  //primaryColor: Colors.blueGrey,
  brightness: Brightness.light,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: Colors.brown,
    backgroundColor: Colors.amberAccent,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.teal,
    unselectedItemColor: Colors.blueGrey,
  ),
);

final ThemeData darkTheme = ThemeData(
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: Colors.black,
    backgroundColor: Colors.amberAccent,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.amberAccent,
    unselectedItemColor: Colors.blueGrey,
  ),
);
