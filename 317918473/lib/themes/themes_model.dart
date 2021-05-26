import 'package:flutter/material.dart';

const backgroundColor = Color(0xff253334);

enum Themes { light, dark }

class MyTheme {
  MyTheme();
  final _themeData = ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(backgroundColor: backgroundColor),
      bottomNavigationBarTheme:
          BottomNavigationBarThemeData(backgroundColor: backgroundColor),
      primaryColor: backgroundColor,
      dialogBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light(),
      fontFamily: 'AlegreyaSans');

  ThemeData light() {
    return _themeData;
  }

  ThemeData dark() {
    return _themeData.copyWith(
      colorScheme: ColorScheme.dark(),
    );
  }

  static ThemeData chooseTheme(Themes themes) {
    switch (themes) {
      case Themes.light:
        return MyTheme().light();
      case Themes.dark:
        return MyTheme().dark();
    }
  }
}
