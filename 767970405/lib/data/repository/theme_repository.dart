import 'package:flutter/material.dart';
import '../theme/custom_theme.dart';

class ThemeRepository {
  final List<CustomTheme> themes = <CustomTheme>[
    CustomTheme(
      selectedMsg: Colors.green[200],
      unselectedMsg: Colors.green[50],
      dataLabel: Colors.red,
      calendar: Colors.red[50],
      bot: Colors.green[50],
      helpWindow: Colors.green[50],
      backgroundCategory: Colors.greenAccent,
      appTheme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.teal,
        accentColor: Colors.amberAccent,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        fontFamily: 'Roboto',
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
      ),
    ),
    CustomTheme(
      selectedMsg: Colors.orangeAccent,
      unselectedMsg: Colors.black,
      dataLabel: Colors.red,
      calendar: Colors.red[50],
      helpWindow: Colors.black,
      bot: Colors.black,
      backgroundCategory: Colors.grey,
      appTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.amberAccent,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.teal,
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
      ),
    ),
  ];
}
