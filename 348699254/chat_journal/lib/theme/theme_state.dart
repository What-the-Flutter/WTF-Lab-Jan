import 'package:flutter/material.dart';

class ThemeState {
  final bool isLightTheme;
  final ThemeData themeData;

  ThemeState({
    required this.isLightTheme,
    required this.themeData,
  });

  ThemeState copyWith({
    bool? isLightTheme,
    ThemeData? themeData,
  }) {
    return ThemeState(
      isLightTheme: isLightTheme ?? this.isLightTheme,
      themeData: themeData ?? this.themeData,
    );
  }

  ThemeState get lightTheme {
    return ThemeState(
      isLightTheme: isLightTheme,
      themeData: ThemeData(
        primarySwatch: Colors.teal,
        iconTheme: const IconThemeData(
          color: Colors.teal,
        ),
        //primaryColor: Colors.blueGrey,
        brightness: Brightness.light,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colors.brown,
          backgroundColor: Colors.amberAccent,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.blueGrey,
        ),
      ),
    );
  }

  ThemeState get darkTheme {
    return ThemeState(
      isLightTheme: isLightTheme,
      themeData: ThemeData(
        primaryColor: Colors.black,
        brightness: Brightness.dark,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colors.black,
          backgroundColor: Colors.amberAccent,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.amberAccent,
          unselectedItemColor: Colors.blueGrey,
        ),
      ),
    );
  }
}
