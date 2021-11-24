import 'package:flutter/material.dart';

enum myThemes { light, dark }

class Themes {
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.indigo,
    ).copyWith(
      secondary: Colors.indigoAccent,
    ),
    textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.black)),
    brightness: Brightness.light,
  );
  static final ThemeData darkTheme = ThemeData(
    accentColor: Colors.indigo,
    brightness: Brightness.dark,
  );
}
