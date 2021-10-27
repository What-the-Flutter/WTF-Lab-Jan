import 'package:flutter/material.dart';
//set state
//названия страниц
const double radiusValue = 10;

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme(
    primary:  Color(0xFF173E47), //appbar
    onPrimary: Color(0xFFFFFFFF), //bottomAppBar, pages, messages
    primaryVariant: Color(0xFFF0F4FA), //page icons

    background: Color(0xFF173E47), //selected icons, text
    onBackground: Color(0xFFEDE6F5), //icons

    //background gradient
    secondary: Color(0xFFDAEDF2),
    onSecondary: Color(0xFFF7FAFE),
    secondaryVariant: Color(0xFFF7EFFC),

    //button gradient
    error: Color(0xFF90DEE5),
    onError: Color(0xFF108098),

    surface: Color(0xFFD0E1E8), //selected items
    onSurface: Color(0xFF87B0BA),

    brightness: Brightness.light,
  ),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme(
    primary: Color(0xFF0A1621), //appbar
    onPrimary: Color(0xFF0A1621), //bottomAppBar, pages, messages
    primaryVariant: Color(0xFF282852), //page icons

    background: Color(0xFFEFF7FA), //selected icons, text
    onBackground: Color(0xFF421D5F), //icons

    //background gradient
    secondary: Color(0xFF09212E),
    onSecondary: Color(0xFF1F1F41),
    secondaryVariant: Color(0xFF411D5F),

    //button gradient
    error: Color(0xFF90DEE5),
    onError: Color(0xFF108098),

    surface: Color(0xFF0D1B29), //selected items
    onSurface: Color(0xFFF7FAFE),

    brightness: Brightness.dark,
  ),
  canvasColor: Color(0xFF0A1621),
  brightness: Brightness.dark,
);
