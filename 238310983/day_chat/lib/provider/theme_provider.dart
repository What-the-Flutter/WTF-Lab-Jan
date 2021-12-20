import 'package:flutter/material.dart';

CustomTheme currentTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = false;

  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme:
          ColorScheme.light(primaryVariant: Colors.grey.withOpacity(0.5), primary: Colors.red, secondary: Colors.blue),
      appBarTheme: AppBarTheme(backgroundColor: Colors.transparent.withOpacity(0.3)),
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: Colors.red,
        secondary: Colors.black,
        primaryVariant: Colors.black.withOpacity(0.3),
      ),
      primaryColor: Colors.black,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.black,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey,
      scaffoldBackgroundColor: Colors.grey,
    );
  }
}
