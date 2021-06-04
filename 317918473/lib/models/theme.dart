import 'package:flutter/material.dart';

const backgroundColor = Color(0xff253334);
const lime = Color(0xffa2c523);
const earth = Color(0xff7d4427);
const mist = Color(0xff9bc01c);
const forestGreen = Color(0xff2e4600);

enum Themes { light, dark }

extension Theming on Themes {
  ThemeData get themeData {
    switch (this) {
      case Themes.light:
        return MyTheme().light();
      case Themes.dark:
        return MyTheme().dark();
    }
  }

  bool get isDark {
    if (this == Themes.dark) {
      return true;
    } else {
      return false;
    }
  }
}

class MyTheme {
  MyTheme();
  final _themeData = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(backgroundColor: backgroundColor),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
    ),
    primaryColor: backgroundColor,
    dialogBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.dark(),
    fontFamily: 'AlegreyaSans',
  );

  ThemeData light() {
    return _themeData.copyWith(
      colorScheme: ColorScheme.light(),
      scaffoldBackgroundColor: Colors.green.shade900,
      primaryColor: Colors.green,
      appBarTheme: AppBarTheme(backgroundColor: Colors.green, elevation: 6),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xfff9aa33),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
      ),
      iconTheme: IconThemeData(color: Colors.black),
      dialogBackgroundColor: earth,
    );
  }

  ThemeData dark() {
    return _themeData;
  }
}
