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

  SettingsState({
    required this.theme,
    required this.isCategoryPanelVisible,
    required this.isCustomDateUsed,
    required this.isMessageSwitchOn,
    required this.isDateSwitchOn,
    required this.useBiometrics,
    required this.messageAlignment,
    required this.dateAlignment,
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
    );
  }
}
