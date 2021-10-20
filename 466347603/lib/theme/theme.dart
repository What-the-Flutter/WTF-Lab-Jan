import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF006766),
  appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF006766)),
  cardColor: const Color(0xFF78909C),
  highlightColor: const Color(0xFFFFD741),
  selectedRowColor: const Color(0xFFBCE3C6),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFFAFAFA),
    selectedItemColor: Color(0xFF006766),
  ),
  primaryTextTheme: const TextTheme(
    bodyText1: TextStyle(
      color: Color(0xFF0A0A0A),
      fontSize: 18,
    ),
    headline6: TextStyle(
      color: Color(0xFFFDFFFE),
    ),
    subtitle2: TextStyle(
      color: Color(0xFF737478),
      fontSize: 18,
    ),
  ),
  primaryIconTheme: const IconThemeData(
    color: Color(0xFFFDFFFE),
  ),
  buttonTheme: const ButtonThemeData(buttonColor: Color(0xFFFFD741)),
  iconTheme: const IconThemeData(color: Color(0xFF006766)),
  backgroundColor: const Color(0xFFF5F5F5),
  scaffoldBackgroundColor: const Color(0xFFFAFAFA),
  dialogBackgroundColor: const Color(0xFFE4F2E3),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF2E3540)),
  primaryColor: const Color(0xFF213244),
  cardColor: const Color(0xFF2E353F),
  selectedRowColor: const Color(0xFF3D4753),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1E2832),
    selectedItemColor: Color(0xFFFFD741),
  ),
  primaryTextTheme: const TextTheme(
    bodyText1: TextStyle(
      color: Color(0xFFFDFFFE),
      fontSize: 18,
    ),
    headline6: TextStyle(
      color: Color(0xFFFDFFFE),
    ),
    subtitle2: TextStyle(
      color: Color(0xFF737478),
      fontSize: 18,
    ),
  ),
  primaryIconTheme: const IconThemeData(
    color: Color(0xFFFDFFFE),
  ),
  iconTheme: const IconThemeData(color: Color(0xFFFDFFFE)),
  buttonTheme: const ButtonThemeData(buttonColor: Color(0xFFFFD741)),
  backgroundColor: const Color(0xFF343E48),
  scaffoldBackgroundColor: const Color(0xFF1E2832),
  dialogBackgroundColor: const Color(0xFF2C353E),
);
