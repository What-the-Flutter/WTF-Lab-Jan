import 'package:flutter/material.dart';

class StatesTheme {
  bool isLightTheme;
  ThemeData themeData;

  StatesTheme({this.isLightTheme, this.themeData});

  StatesTheme copyWith({
    bool isLightTheme,
    ThemeData themeData,
  }) {
    var state = StatesTheme();
    state.isLightTheme = isLightTheme ?? this.isLightTheme;
    state.themeData ?? themeData ?? this.themeData;
    return state;
  }

  StatesTheme get lightTheme {
    return StatesTheme(
      isLightTheme: true,
      themeData: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: IconThemeData(
          color: Colors.deepPurple,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromRGBO(30, 144, 255, 100),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
        appBarTheme: AppBarTheme(
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
        brightness: Brightness.dark,
        accentColor: Colors.orangeAccent,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.orangeAccent,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.orangeAccent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
        ),
      ),
    );
  }
}
