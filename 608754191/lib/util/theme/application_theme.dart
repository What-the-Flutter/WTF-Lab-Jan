import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData.light();

ThemeData darkTheme = ThemeData.dark();

ThemeData ownTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.grey,
  primarySwatch: Colors.blueGrey,
  dialogBackgroundColor: Colors.blueGrey,
  focusColor: Colors.blueGrey,
  accentColor: Colors.grey,
  backgroundColor: Colors.yellow,
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    foregroundColor: Colors.white,
  ),
  buttonColor: Colors.grey,
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        Colors.red,
      ),
    ),
  ),
);
