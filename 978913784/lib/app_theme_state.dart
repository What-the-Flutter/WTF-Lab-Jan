import 'package:flutter/material.dart';

class AppThemeState {
  final bool usingLightTheme;

  final ThemeData theme;

  const AppThemeState({
    @required this.usingLightTheme,
    @required this.theme,
  });

  AppThemeState copyWith({
    bool usingLightTheme,
    ThemeData theme,
  }) {
    return AppThemeState(
      usingLightTheme: usingLightTheme ?? this.usingLightTheme,
      theme: theme ?? this.theme,
    );
  }

  static AppThemeState get lightTheme {
    return AppThemeState(
      usingLightTheme: true,
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.purple.shade900,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black),
          bodyText2: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          caption: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        dividerColor: Colors.black,
        toggleableActiveColor: Colors.purple.shade900,
        shadowColor: Colors.purple,
        accentIconTheme: IconThemeData(color: Colors.white),
        colorScheme: ColorScheme.light(
          primary: Colors.purple.shade900,
          secondary: Colors.purple.shade900,
          background: Colors.white,
        ),
      ),
    );
  }

  static AppThemeState get darkTheme {
    return AppThemeState(
      usingLightTheme: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.purple.shade900,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          caption: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        dividerColor: Colors.white,
        toggleableActiveColor: Colors.purple.shade900,
        shadowColor: Colors.purple,
        accentIconTheme: IconThemeData(color: Colors.white),
        colorScheme: ColorScheme.dark(
          primary: Colors.purple,
          secondary: Colors.white,
          background: Colors.black,
          onPrimary: Colors.white,
          surface: Colors.black,
        ),
      ),
    );
  }
}
