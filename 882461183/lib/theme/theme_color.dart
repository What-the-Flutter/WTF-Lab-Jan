import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
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
