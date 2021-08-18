import 'package:equatable/equatable.dart';

import 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class InitialSettingsState extends SettingsState {
  const InitialSettingsState();
}

class MainSettingsState extends SettingsState {
  final bool isDarkMode;
  final bool isRightBubbleAlignment;
  final bool canCheckBiometrics;
  final BiometricsCheck checkBiometrics;
  final bool showBiometricsDialog;
  final bool isDateTimeModificationEnabled;
  final SettingsFontSize fontSize;
  late final bool settingsChanged;

  MainSettingsState({
    required this.canCheckBiometrics,
    required this.checkBiometrics,
    required this.isDarkMode,
    required this.isRightBubbleAlignment,
    required this.showBiometricsDialog,
    required this.isDateTimeModificationEnabled,
    required this.fontSize,
  }) {
    settingsChanged = isDarkMode ||
        isRightBubbleAlignment ||
        checkBiometrics == BiometricsCheck.enabled ||
        isDateTimeModificationEnabled ||
        fontSize != SettingsFontSize.normal;
  }

  MainSettingsState copyWith({
    bool? canCheckBiometrics,
    BiometricsCheck? checkBiometrics,
    bool? isDarkMode,
    bool? isRightBubbleAlignment,
    bool? isDateTimeModificationEnabled,
    SettingsFontSize? fontSize,
  }) {
    return MainSettingsState(
      canCheckBiometrics: canCheckBiometrics ?? this.canCheckBiometrics,
      checkBiometrics: checkBiometrics ?? this.checkBiometrics,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isRightBubbleAlignment: isRightBubbleAlignment ?? this.isRightBubbleAlignment,
      isDateTimeModificationEnabled:
          isDateTimeModificationEnabled ?? this.isDateTimeModificationEnabled,
      showBiometricsDialog: showBiometricsDialog,
      fontSize: fontSize ?? this.fontSize,
    );
  }

  @override
  List<Object?> get props => [
        canCheckBiometrics,
        checkBiometrics,
        isDarkMode,
        isRightBubbleAlignment,
        isDateTimeModificationEnabled,
        fontSize,
      ];
}
