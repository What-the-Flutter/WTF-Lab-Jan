import 'package:flutter/material.dart';

class Themes {
  static const Map<int, Color> color = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
        primarySwatch: const MaterialColor(0xFFD0BCFF, color))
        //.copyWith(brightness: Brightness.dark)
        .copyWith(primary: const Color(0xFFD0BCFF))
        .copyWith(onPrimary: const Color(0xFF381E72))
        .copyWith(primaryVariant: const Color(0xFFAD96D7))
        .copyWith(secondary: const Color(0xFFCCC2DC))
        .copyWith(onSecondary: const Color(0xFF332D41))
        .copyWith(secondaryVariant: const Color(0xFFA39AAF))
        .copyWith(error: const Color(0xFFF2B8B5))
        .copyWith(onError: const Color(0xFF601410))
        .copyWith(background: const Color(0xFF1C1B1F))
        .copyWith(onBackground: const Color(0xFFE6E1E5))
        .copyWith(surface: const Color(0xFF1C1B1F))
        .copyWith(onSurface: const Color(0xFFE6E1E5)),
  );

  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
        primarySwatch: const MaterialColor(0xFFB3261E, color))
        //.copyWith(brightness: Brightness.light)
        .copyWith(primary: const Color(0xFF6750A4))
        .copyWith(onPrimary: const Color(0xFFFFFFFF))
        .copyWith(primaryVariant: const Color(0xFF563F95))
        .copyWith(secondary: const Color(0xFF625B71))
        .copyWith(onSecondary: const Color(0xFFFFFFFF))
        .copyWith(secondaryVariant: const Color(0xFF50475F))
        .copyWith(error: const Color(0xFFB3261E))
        .copyWith(onError: const Color(0xFFFFFFFF))
        .copyWith(background: const Color(0xFFFFFBFE))
        .copyWith(onBackground: const Color(0xFF1C1B1F))
        .copyWith(surface: const Color(0xFFFFFBFE))
        .copyWith(onSurface: const Color(0xFF1C1B1F)),
  );
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get theme => _themeMode;

  void toggleTheme(bool isDarkTheme) {
    _themeMode = isDarkTheme ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
