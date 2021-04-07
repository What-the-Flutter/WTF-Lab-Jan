import 'package:flutter/material.dart';

class ThemeStates {
  final bool isLightTheme;
  final ThemeData theme;
  final TextTheme textTheme;

  const ThemeStates({
     this.isLightTheme,
     this.theme,
     this.textTheme,
  });

  ThemeStates copyWith({
   final bool isLightTheme,
   final ThemeData theme,
   final TextTheme textTheme,
  }) {
    return ThemeStates(
      isLightTheme: isLightTheme ?? this.isLightTheme,
      theme: theme ?? this.theme,
      textTheme: textTheme ?? this.textTheme,
    );
  }

   ThemeStates get darkTheme {
    return ThemeStates(
      isLightTheme: isLightTheme,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Colors.indigo,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedItemColor: Colors.white60,
          selectedItemColor: Colors.indigo,
          showUnselectedLabels: true,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        brightness: Brightness.dark,
        textTheme: textTheme,
      ),
      textTheme: textTheme,
    );
  }

   ThemeStates get lightTheme {
    return ThemeStates(
      isLightTheme: isLightTheme,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedItemColor: Colors.blueGrey,
          selectedItemColor: Colors.blue,
          showUnselectedLabels: true,
        ),
        iconTheme: IconThemeData(
          color: Colors.blueGrey,
        ),
        brightness: Brightness.light,
        textTheme: textTheme,
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
