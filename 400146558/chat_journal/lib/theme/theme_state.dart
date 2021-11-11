import 'package:chat_journal/theme/theme_constants.dart';
import 'package:flutter/material.dart';

class ThemeState {
  late ThemeData themeData;
  bool isLight;

  ThemeState({required this.isLight}) {
    if (isLight) {
      themeData = MyThemes.lightTheme;
    } else {
      themeData = MyThemes.darkTheme;
    }
  }

  ThemeState copyWith({required bool isLight}) => ThemeState(isLight: isLight);
}
