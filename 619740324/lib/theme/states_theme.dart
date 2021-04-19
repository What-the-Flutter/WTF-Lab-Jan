import 'package:flutter/material.dart';

class StatesTheme {
  final bool isLightTheme;
  final ThemeData themeData;
  final TextTheme textTheme;

  StatesTheme({this.isLightTheme, this.themeData, this.textTheme});

  StatesTheme copyWith({
    final bool isLightTheme,
    final ThemeData themeData,
    final TextTheme textTheme,
  }) {
    return StatesTheme(
      isLightTheme: isLightTheme ?? this.isLightTheme,
      themeData: themeData ?? this.themeData,
      textTheme: textTheme ?? this.textTheme,
    );
  }

  StatesTheme get lightTheme {
    return StatesTheme(
      isLightTheme: true,
      themeData: ThemeData(
        textTheme: textTheme,
        cardColor: Colors.blueGrey[100],
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
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
      textTheme: textTheme,
    );
  }

  StatesTheme get darkTheme {
    return StatesTheme(
      isLightTheme: false,
      themeData: ThemeData(
        textTheme: textTheme,
        brightness: Brightness.dark,
        accentColor: Colors.yellow,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.yellow,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.yellow,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
        ),
      ),
      textTheme: textTheme,
    );
  }

  static const TextTheme largeTextTheme = TextTheme(
    subtitle1: TextStyle(
      fontSize: 17,
    ),
    bodyText2: TextStyle(
      fontSize: 15,
    ),
    bodyText1: TextStyle(
      fontSize: 17,
    ),
  );

  static const TextTheme defaultTextTheme = TextTheme(
    subtitle1: TextStyle(
      fontSize: 16,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
    ),
    bodyText1: TextStyle(
      fontSize: 15,
    ),
  );

  static const TextTheme smallTextTheme = TextTheme(
    subtitle1: TextStyle(
      fontSize: 14,
    ),
    bodyText2: TextStyle(
      fontSize: 12,
    ),
    bodyText1: TextStyle(
      fontSize: 14,
    ),
  );
}
