import 'package:flutter/material.dart';

class ThemeStates {
  final bool? isDarkMode;
  final ThemeData? themeData;

  ThemeStates({this.isDarkMode, this.themeData});

  ThemeStates copyWith({
    bool? isDarkMode,
    ThemeData? themeData,
  }) {
    return ThemeStates(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      themeData: themeData ?? this.themeData,
    );
  }

  ThemeStates get lightTheme {
    return ThemeStates(
      isDarkMode: false,
      themeData: ThemeData(
        backgroundColor: const Color(0xffFFC107),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xff512DA8),
          unselectedItemColor: Color(0xff000000),
        ),
        scaffoldBackgroundColor: const Color(0xffFFFFFF),
        primaryColor: const Color(0xffFFFFFF),
        accentColor: const Color(0xff512DA8),
        primaryColorLight: const Color(0xff512DA8).withAlpha(50),
      ),
    );
  }

  ThemeStates get darkTheme {
    return ThemeStates(
      isDarkMode: true,
      themeData: ThemeData.dark(),
    );
  }

}