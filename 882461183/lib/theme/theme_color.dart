import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromRGBO(254, 214, 67, 1),
    foregroundColor: Colors.black,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromRGBO(0, 103, 102, 1),
    foregroundColor: Color.fromRGBO(235, 254, 255, 1),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color.fromRGBO(250, 250, 250, 1),
    unselectedItemColor: Color.fromRGBO(115, 115, 115, 1),
    selectedItemColor: Color.fromRGBO(8, 97, 102, 1),
  ),
  iconTheme: const IconThemeData(color: Color.fromRGBO(235, 254, 255, 1)),
  scaffoldBackgroundColor: const Color.fromRGBO(250, 250, 250, 1),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color.fromRGBO(250, 250, 250, 1),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: Colors.black,
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color.fromRGBO(0, 103, 102, 1),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Color.fromRGBO(212, 237, 213, 1),
  ),
  dialogBackgroundColor: const Color.fromRGBO(250, 250, 250, 1),
  colorScheme: const ColorScheme(
    primary: Color.fromRGBO(0, 103, 102, 1), //appbar, bg icons
    onPrimary: Color.fromRGBO(254, 214, 67, 1), //floatActionButton
    primaryVariant: Color.fromRGBO(212, 237, 213, 1), // events

    secondary: Colors.black, // text
    onSecondary: Color.fromRGBO(115, 115, 115, 1), //bottombar unselected items
    secondaryVariant: Color.fromRGBO(188, 227, 198, 1), // selected events

    background: Color.fromRGBO(250, 250, 250, 1), // bg, bottom appbar
    onBackground: Color.fromRGBO(8, 97, 102, 1), // selected bottombar items

    surface: Color.fromRGBO(235, 254, 255, 1), //appbar itmes
    onSurface: Color.fromRGBO(205, 205, 205, 1), // subtext

    brightness: Brightness.light,

    error: Colors.red,
    onError: Colors.redAccent,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromRGBO(251, 215, 65, 1),
    foregroundColor: Colors.black,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromRGBO(33, 50, 68, 1),
    foregroundColor: Color.fromRGBO(254, 255, 253, 1),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color.fromRGBO(30, 40, 50, 1),
    unselectedItemColor: Color.fromRGBO(189, 191, 193, 1),
    selectedItemColor: Color.fromRGBO(251, 215, 65, 1),
  ),
  scaffoldBackgroundColor: const Color.fromRGBO(30, 40, 50, 1),
  iconTheme: const IconThemeData(color: Color.fromRGBO(254, 255, 253, 1)),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: Colors.white,
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color.fromRGBO(33, 50, 68, 1),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Color.fromRGBO(46, 54, 63, 1),
  ),
  dialogBackgroundColor: const Color.fromRGBO(30, 40, 50, 1),
  colorScheme: const ColorScheme(
    primary: Color.fromRGBO(33, 50, 68, 1),
    onPrimary: Color.fromRGBO(251, 215, 65, 1),
    primaryVariant: Color.fromRGBO(46, 54, 63, 1),
    secondary: Color.fromRGBO(255, 255, 255, 1),
    onSecondary: Color.fromRGBO(189, 191, 193, 1),
    secondaryVariant: Color.fromRGBO(61, 71, 83, 1),
    background: Color.fromRGBO(30, 40, 50, 1),
    surface: Color.fromRGBO(254, 255, 253, 1),
    onSurface: Color.fromRGBO(88, 92, 98, 1),
    brightness: Brightness.dark,
    onBackground: Color.fromRGBO(251, 215, 65, 1),
    error: Colors.red,
    onError: Colors.redAccent,
  ),
);
