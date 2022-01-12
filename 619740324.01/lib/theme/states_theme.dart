import 'package:flutter/material.dart';

class StatesTheme {
  final bool? isLightTheme;
  final ThemeData? themeData;

  StatesTheme({this.isLightTheme, this.themeData});

  StatesTheme copyWith({
    final bool? isLightTheme,
    final ThemeData? themeData,
  }) {
    return StatesTheme(
      isLightTheme: isLightTheme ?? this.isLightTheme,
      themeData: themeData ?? this.themeData,
    );
  }

  StatesTheme get lightTheme {
    return StatesTheme(
      isLightTheme: true,
      themeData: ThemeData(
        backgroundColor: Colors.deepPurple,
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: const IconThemeData(
          color: Colors.deepPurple,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.deepPurple,
          centerTitle: true,
        ),
      ),
    );
  }

  StatesTheme get darkTheme {
    return StatesTheme(
      isLightTheme: false,
      themeData: ThemeData(
        backgroundColor: Colors.black,
        primarySwatch: Colors.yellow,
        brightness: Brightness.dark,
        iconTheme: const IconThemeData(
          color: Colors.yellow,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.yellow,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.yellow,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
    );
  }
}
