import 'package:flutter/material.dart';

class SettingsState {
  final ThemeData theme;
  final bool isCategoryPanelVisible;
  final bool isCustomDateUsed;
  final bool isMessageSwitchOn;
  final bool isDateSwitchOn;
  final bool useBiometrics;
  final Alignment messageAlignment;
  final Alignment dateAlignment;
  final int smallFontSize;
  final int mediumFontSize;
  final int largeFontSize;
  final int fontSize;

  SettingsState({
    required this.theme,
    required this.isCategoryPanelVisible,
    required this.isCustomDateUsed,
    required this.isMessageSwitchOn,
    required this.isDateSwitchOn,
    required this.useBiometrics,
    required this.messageAlignment,
    required this.dateAlignment,
    required this.smallFontSize,
    required this.mediumFontSize,
    required this.largeFontSize,
    required this.fontSize,
  });

  SettingsState copyWith({
    ThemeData? theme,
    bool? isCategoryPanelVisible,
    bool? isCustomDateUsed,
    bool? isMessageSwitchOn,
    bool? isDateSwitchOn,
    bool? useBiometrics,
    Alignment? messageAlignment,
    Alignment? dateAlignment,
    int? smallFontSize,
    int? mediumFontSize,
    int? largeFontSize,
    int? fontSize,
  }) {
    return SettingsState(
      theme: theme ?? this.theme,
      isCategoryPanelVisible:
          isCategoryPanelVisible ?? this.isCategoryPanelVisible,
      isCustomDateUsed: isCustomDateUsed ?? this.isCustomDateUsed,
      isMessageSwitchOn: isMessageSwitchOn ?? this.isMessageSwitchOn,
      isDateSwitchOn: isDateSwitchOn ?? this.isDateSwitchOn,
      useBiometrics: useBiometrics ?? this.useBiometrics,
      messageAlignment: messageAlignment ?? this.messageAlignment,
      dateAlignment: dateAlignment ?? this.dateAlignment,
      smallFontSize: smallFontSize ?? this.smallFontSize,
      mediumFontSize: mediumFontSize ?? this.mediumFontSize,
      largeFontSize: largeFontSize ?? this.largeFontSize,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}
