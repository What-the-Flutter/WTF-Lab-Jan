import 'package:flutter/material.dart';

class SettingsState {
  final bool isCategoryListOpen;
  final bool isBiometricAuth;
  final bool isLightTheme;
  final ThemeData themeData;

  SettingsState({
    required this.isCategoryListOpen,
    required this.isBiometricAuth,
    required this.isLightTheme,
    required this.themeData,
  });

  SettingsState copyWith({
    bool? isCategoryListOpen,
    bool? isBiometricAuth,
    bool? isLightTheme,
    ThemeData? themeData,
  }) {
    return SettingsState(
      isCategoryListOpen: isCategoryListOpen ?? this.isCategoryListOpen,
      isBiometricAuth: isBiometricAuth ?? this.isBiometricAuth,
      isLightTheme: isLightTheme ?? this.isLightTheme,
      themeData: themeData ?? this.themeData,
    );
  }
}
