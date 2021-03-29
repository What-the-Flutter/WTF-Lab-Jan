import 'package:flutter/material.dart';
import 'theme.dart';

class ThemeState {
  final bool isLightTheme;
  final ThemeData theme;

  const ThemeState({
    @required this.isLightTheme,
    @required this.theme,
  });

  ThemeState copyWith({
    bool isLightTheme,
    ThemeData theme,
  }) {
    return ThemeState(
      isLightTheme: isLightTheme ?? this.isLightTheme,
      theme: theme ?? this.theme,
    );
  }

  static ThemeState get lightTheme {
    return ThemeState(
      isLightTheme: true,
      theme: lightThemeCustom,
    );
  }

  static ThemeState get darkTheme {
    return ThemeState(
      isLightTheme: false,
      theme: darkThemeCustom,
    );
  }
}
