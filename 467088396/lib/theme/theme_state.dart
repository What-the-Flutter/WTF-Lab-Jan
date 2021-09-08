import 'package:flutter/material.dart';
import 'themes.dart';


class ThemeState{
  late ThemeData themeData;
  bool isLight;

  ThemeState({required this.isLight}) {
    if (isLight) {
      themeData = lightTheme;
    }
    else {
      themeData = darkTheme;
    }
  }

  ThemeState copyWith({required bool isLight}) => ThemeState(isLight: isLight);
}
