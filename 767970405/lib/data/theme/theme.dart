import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.black,
  cardColor: Colors.black,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.amberAccent,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.amberAccent,
    unselectedItemColor: Colors.grey,
  ),
  textTheme: TextTheme(
    subtitle1: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    bodyText2: TextStyle(
      color: Colors.white.withOpacity(0.4),
      fontSize: 16,
    ),
  ),
);

ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: Colors.teal,
  accentColor: Colors.amberAccent,
  cardColor: Colors.grey,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.amberAccent,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.teal,
    unselectedItemColor: Colors.grey,
  ),
  textTheme: TextTheme(
    subtitle1: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    bodyText2: TextStyle(
      color: Colors.black.withOpacity(0.4),
      fontSize: 16,
    ),
  ),
);
