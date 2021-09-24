import 'package:flutter/material.dart';

class ColorThemeState {
  final bool usingLightTheme;

  final ThemeData theme;

  const ColorThemeState({
    required this.usingLightTheme,
    required this.theme,
  });

  ColorThemeState copyWith({
    bool? usingLightTheme,
    ThemeData? theme,
  }) {
    return ColorThemeState(
      usingLightTheme: usingLightTheme ?? this.usingLightTheme,
      theme: theme ?? this.theme,
    );
  }

  static ColorThemeState get lightTheme {
    return ColorThemeState(
      usingLightTheme: true,
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.blue.shade900,
        textTheme: const TextTheme(
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
        toggleableActiveColor: Colors.blue.shade900,
        shadowColor: Colors.blue,
        accentIconTheme: const IconThemeData(color: Colors.white),
        colorScheme: ColorScheme.light(
          primary: Colors.blue.shade900,
          secondary: Colors.blue.shade900,
          background: Colors.white,
        ),
      ),
    );
  }

  static ColorThemeState get darkTheme {
    return ColorThemeState(
      usingLightTheme: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.blue.shade900,
        textTheme: const TextTheme(
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
        toggleableActiveColor: Colors.blue.shade900,
        shadowColor: Colors.blue,
        accentIconTheme: const IconThemeData(color: Colors.white),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.white,
          background: Colors.black,
          onPrimary: Colors.white,
          surface: Colors.black,
        ),
      ),
    );
  }
}
