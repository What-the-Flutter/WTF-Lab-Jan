import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: Colors.white,
  accentColor: Colors.indigoAccent,
  brightness: Brightness.light,
  accentIconTheme: const IconThemeData(color: Colors.white),
  iconTheme: const IconThemeData(color: Colors.indigoAccent),
  textTheme: const TextTheme(
      bodyText1: TextStyle(
        color: Colors.black87,
        fontSize: FontSize.normal,
        fontWeight: FontWeight.bold,
      ),
      bodyText2: TextStyle(color: Colors.black87),
      subtitle2: TextStyle(
        color: Colors.black38,
        fontSize: FontSize.small,
      ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Colors.indigoAccent,
      padding: const EdgeInsets.all(Insets.xsmall),
    ),
  ),
  fontFamily: Fonts.ubuntu,
);

ThemeData darkTheme = ThemeData(
  accentColor: Colors.indigoAccent,
  accentIconTheme: const IconThemeData(color: Colors.white70),
  iconTheme: const IconThemeData(color: Colors.white70),
  textTheme: const TextTheme(
      bodyText1: TextStyle(
        color: Colors.white70,
        fontSize: FontSize.normal,
        fontWeight: FontWeight.bold,
      ),
      bodyText2: TextStyle(color: Colors.white70),
      subtitle2: TextStyle(
        color: Colors.white60,
        fontSize: FontSize.small,
      ),
  ),
  brightness: Brightness.dark,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Colors.indigoAccent,
      padding: const EdgeInsets.all(Insets.xsmall),
    ),
  ),
  fontFamily: Fonts.ubuntu,
);
