import 'package:flutter/material.dart';

class SettingsState {
  final bool isCategoryListOpen;
  final bool isBiometricAuth;
  final bool isLightTheme;
  final bool isRightBubbleAlignment;
  final double smallFontSize;
  final double mediumFontSize;
  final double largeFontSize;
  final double chosenFontSize;
  final ThemeData themeData;

  SettingsState({
    required this.isCategoryListOpen,
    required this.isBiometricAuth,
    required this.isLightTheme,
    required this.isRightBubbleAlignment,
    required this.smallFontSize,
    required this.mediumFontSize,
    required this.largeFontSize,
    required this.chosenFontSize,
    required this.themeData,
  });

  SettingsState copyWith({
    bool? isCategoryListOpen,
    bool? isBiometricAuth,
    bool? isLightTheme,
    bool? isRightBubbleAlignment,
    double? smallFontSize,
    double? mediumFontSize,
    double? largeFontSize,
    double? chosenFontSize,
    ThemeData? themeData,
  }) {
    return SettingsState(
      isCategoryListOpen: isCategoryListOpen ?? this.isCategoryListOpen,
      isBiometricAuth: isBiometricAuth ?? this.isBiometricAuth,
      isLightTheme: isLightTheme ?? this.isLightTheme,
      isRightBubbleAlignment:
          isRightBubbleAlignment ?? this.isRightBubbleAlignment,
      smallFontSize: smallFontSize ?? this.smallFontSize,
      mediumFontSize: mediumFontSize ?? this.mediumFontSize,
      largeFontSize: largeFontSize ?? this.largeFontSize,
      chosenFontSize: chosenFontSize ?? this.chosenFontSize,
      themeData: themeData ?? this.themeData,
    );
  }
}
