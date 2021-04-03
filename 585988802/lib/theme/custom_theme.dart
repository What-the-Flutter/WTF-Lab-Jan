import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  appBarTheme: AppBarTheme(
    color: Color.fromRGBO(46, 46, 46, 1),
  ),
  scaffoldBackgroundColor: Color.fromRGBO(46, 46, 46, 1),
  primaryColor: Colors.white38,
  accentColor: Colors.white,
  colorScheme: ColorScheme.dark(),
  iconTheme: IconThemeData(color: Colors.white),
  cardColor: Colors.white24,
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Color.fromRGBO(46, 46, 46, 1),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.purple.shade300,
    foregroundColor: Colors.black,
  ),
  backgroundColor: Colors.black26,
  cardTheme: CardTheme(
    color: Colors.white12,
  ),
  dialogBackgroundColor: Color.fromRGBO(151, 157, 155, 1),
  bottomAppBarColor: Color.fromRGBO(46, 46, 46, 1),
  dividerColor: Colors.white38,
  secondaryHeaderColor: Colors.white,
  buttonColor: Colors.white,
  hintColor: Color.fromRGBO(46, 46, 46, 1),
  indicatorColor: Colors.purple.shade300,
);

final lightTheme = ThemeData(
  appBarTheme: AppBarTheme(color: Colors.red),
  scaffoldBackgroundColor: Colors.red,
  primaryColor: Colors.white,
  accentColor: Colors.black,
  colorScheme: ColorScheme.light(),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  cardColor: Colors.redAccent.shade100,
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Color.fromRGBO(236, 67, 67, 1),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
  ),
  backgroundColor: Colors.white,
  cardTheme: CardTheme(
    color: Color(0xFFFFEFEE),
  ),
  dialogBackgroundColor: Colors.white,
  bottomAppBarColor: Colors.white,
  dividerColor: Colors.white38,
  secondaryHeaderColor: Colors.white,
  buttonColor: Colors.black54,
  hintColor: Colors.white,
  indicatorColor: Colors.red,
);
