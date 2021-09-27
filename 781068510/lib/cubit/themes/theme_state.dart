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
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
          ),
          color: Colors.white,
        ),
        dialogBackgroundColor: Colors.white,
        backgroundColor: const Color(0xffFFC107),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xff512DA8),
          unselectedItemColor: Color(0xff000000),
        ),
        scaffoldBackgroundColor: const Color(0xffFFFFFF),
        primaryColor: const Color(0xffFFFFFF),
        primaryColorLight: const Color(0xff512DA8).withAlpha(50),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xff512DA8),
        ),
      ),
    );
  }

  ThemeStates get darkTheme {
    return ThemeStates(
      isDarkMode: true,
      themeData: ThemeData.dark().copyWith(
        canvasColor: Colors.black,
        dialogBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
          color: Colors.black,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
        ),
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
      ),
    );
  }
}
