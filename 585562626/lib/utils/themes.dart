import 'package:flutter/material.dart';

import 'constants.dart';

final darkAccentColor = Colors.indigo;

ThemeData lightTheme({double fontSizeRatio = 1}) => ThemeData(
      primaryColor: Colors.white,
      accentColor: Colors.indigoAccent,
      brightness: Brightness.light,
      accentIconTheme: const IconThemeData(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.indigoAccent),
      primaryIconTheme: const IconThemeData(color: Colors.indigoAccent),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.indigoAccent),
        backgroundColor: Colors.white,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: Colors.indigoAccent,
        cursorColor: Colors.indigoAccent,
      ),
      indicatorColor: Colors.indigoAccent,
      textTheme: TextTheme(
        bodyText1: TextStyle(
          color: Colors.black87,
          fontSize: FontSize.normal * fontSizeRatio,
          fontWeight: FontWeight.bold,
        ),
        bodyText2: TextStyle(color: Colors.black87, fontSize: FontSize.medium * fontSizeRatio),
        subtitle1: TextStyle(fontSize: FontSize.medium * fontSizeRatio),
        subtitle2: TextStyle(color: Colors.black38, fontSize: FontSize.small * fontSizeRatio),
        headline4: TextStyle(fontSize: FontSize.big * fontSizeRatio),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: Colors.indigoAccent,
          padding: const EdgeInsets.all(Insets.xsmall),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(primary: Colors.indigoAccent),
      ),
      sliderTheme: SliderThemeData(
        thumbColor: Colors.indigoAccent,
        activeTrackColor: Colors.indigo,
        inactiveTrackColor: Colors.indigo.withAlpha(Alpha.alpha50),
        inactiveTickMarkColor: Colors.indigo,
      ),
      fontFamily: Fonts.ubuntu,
    );

ThemeData darkTheme({double fontSizeRatio = 1}) => ThemeData(
      accentColor: Colors.indigoAccent,
      accentIconTheme: const IconThemeData(color: Colors.white70),
      iconTheme: const IconThemeData(color: Colors.white70),
      primaryIconTheme: const IconThemeData(color: Colors.indigoAccent),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.indigoAccent),
      ),
      indicatorColor: Colors.indigoAccent,
      textTheme: TextTheme(
        bodyText1: TextStyle(
          color: Colors.white70,
          fontSize: FontSize.normal * fontSizeRatio,
          fontWeight: FontWeight.bold,
        ),
        bodyText2: TextStyle(color: Colors.white70, fontSize: FontSize.medium * fontSizeRatio),
        subtitle1: TextStyle(fontSize: FontSize.medium * fontSizeRatio),
        subtitle2: TextStyle(color: Colors.white60, fontSize: FontSize.small * fontSizeRatio),
        headline4: TextStyle(fontSize: FontSize.big * fontSizeRatio),
      ),
      brightness: Brightness.dark,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: Colors.indigoAccent,
          padding: const EdgeInsets.all(Insets.xsmall),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: Colors.indigoAccent,
        cursorColor: Colors.indigoAccent,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(primary: Colors.indigoAccent),
      ),
      sliderTheme: SliderThemeData(
        thumbColor: Colors.indigoAccent,
        activeTrackColor: Colors.indigo,
        inactiveTrackColor: Colors.indigo.shade100.withAlpha(Alpha.alpha50),
        inactiveTickMarkColor: Colors.white54,
      ),
      fontFamily: Fonts.ubuntu,
    );
