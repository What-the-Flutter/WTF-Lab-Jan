import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOnPressed) {
    themeMode = isOnPressed ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

// ignore: avoid_classes_with_only_static_members
class CustomThemes {
  static final darkTheme = ThemeData(
    appBarTheme: AppBarTheme(color: Color.fromRGBO(46, 46, 46, 1)),
    scaffoldBackgroundColor: Color.fromRGBO(46, 46, 46, 1),
    primaryColor: Colors.white38,
    accentColor: Colors.white,
    colorScheme: ColorScheme.dark(),
    iconTheme: IconThemeData(color: Colors.white),
    cardColor: Colors.white24,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Color.fromRGBO(46, 46, 46, 0.9),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.purple.shade300, foregroundColor: Colors.black),
    backgroundColor: Colors.black26,
    cardTheme: CardTheme(
      color: Colors.white12,
    ),
  );

  static final lightTheme = ThemeData(
    appBarTheme: AppBarTheme(color: Colors.red),
    scaffoldBackgroundColor: Colors.red,
    primaryColor: Colors.white,
    accentColor: Colors.black,
    colorScheme: ColorScheme.light(),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    cardColor: Colors.redAccent.shade100,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Color.fromRGBO(236, 67, 67, 0.9),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.red, foregroundColor: Colors.white),
    backgroundColor: Colors.white,
    cardTheme: CardTheme(
      color: Color(0xFFFFEFEE),
    ),
  );
}
