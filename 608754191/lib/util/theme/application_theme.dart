import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData.light();

ThemeData darkTheme = ThemeData.dark();

ThemeData ownTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.grey,
  dialogBackgroundColor: Colors.blueGrey,
  focusColor: Colors.blueGrey,
  backgroundColor: Colors.yellow,
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    foregroundColor: Colors.white,
  ),
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
  colorScheme:
      ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(secondary: Colors.grey),
);
