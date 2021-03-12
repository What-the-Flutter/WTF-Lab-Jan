import 'package:flutter/material.dart';

class AppThemeState {
  final bool usingLightTheme;

  final Color mainColor;
  final Color mainTextColor;
  final Color accentColor;
  final Color accentLightColor;
  final Color accentTextColor;
  final Color shadowColor;

  const AppThemeState({
    @required this.usingLightTheme,
    @required this.mainColor,
    @required this.mainTextColor,
    @required this.accentColor,
    @required this.accentLightColor,
    @required this.accentTextColor,
    @required this.shadowColor,
  });

  AppThemeState copyWith({
    bool usingLightTheme,
    Color mainColor,
    Color mainTextColor,
    Color accentColor,
    Color accentLightColor,
    Color accentTextColor,
    Color shadowColor,
  }) {
    return AppThemeState(
      usingLightTheme: usingLightTheme ?? this.usingLightTheme,
      mainColor: mainColor ?? this.mainColor,
      mainTextColor: mainTextColor ?? this.mainTextColor,
      accentColor: accentColor ?? this.accentColor,
      accentLightColor: accentLightColor ?? this.accentLightColor,
      accentTextColor: accentTextColor ?? this.accentTextColor,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  static AppThemeState get lightTheme {
    return AppThemeState(
      usingLightTheme: true,
      mainColor: Colors.white,
      mainTextColor: Colors.black,
      accentColor: Colors.purple.shade900,
      accentLightColor: Colors.purple.shade600,
      accentTextColor: Colors.white,
      shadowColor: Colors.black,
    );
  }

  static AppThemeState get darkTheme {
    return AppThemeState(
      usingLightTheme: false,
      mainColor: Color(0xFF121212),
      mainTextColor: Colors.white,
      accentColor: Colors.purple.shade900,
      accentLightColor: Colors.purple.shade600,
      accentTextColor: Colors.white,
      shadowColor: Colors.deepPurple,
    );
  }
}
