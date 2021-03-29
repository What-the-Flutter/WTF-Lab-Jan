import 'package:flutter/material.dart';

final darkThemeCustom = ThemeData(
  primaryColor: Colors.black,
  accentColor: Colors.orange,
  disabledColor: Colors.white,
  backgroundColor: Colors.grey[100],
  unselectedWidgetColor: Colors.white,
  fontFamily: 'Quicksand',
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    unselectedItemColor: Colors.white,
  ),
  textTheme: TextTheme(
    bodyText2: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
  ),
  cardColor: Colors.orange,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.orange,
  ),
);

final lightThemeCustom = ThemeData(
  primaryColor: Colors.deepPurple,
  accentColor: Colors.orange,
  disabledColor: Colors.deepPurple,
  backgroundColor: Colors.white,
  unselectedWidgetColor: Colors.deepPurple,
  fontFamily: 'Quicksand',
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    unselectedItemColor: Colors.deepPurple,
  ),
  textTheme: TextTheme(
    bodyText2: TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
  ),
  cardColor: Colors.orange,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.orange,
  ),
);
