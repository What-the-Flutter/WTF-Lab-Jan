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
  final BiometricsCheck checkBiometrics;
  final bool showBiometricsDialog;
  final bool isDateTimeModificationEnabled;

  const MainSettingsState({
    required this.checkBiometrics,
    required this.isDarkMode,
    required this.isRightBubbleAlignment,
    required this.showBiometricsDialog,
    required this.isDateTimeModificationEnabled,
  });

  MainSettingsState copyWith({
    BiometricsCheck? checkBiometrics,
    bool? isDarkMode,
    bool? isRightBubbleAlignment,
    bool? isDateTimeModificationEnabled,
  }) {
    return MainSettingsState(
        checkBiometrics: checkBiometrics ?? this.checkBiometrics,
        isDarkMode: isDarkMode ?? this.isDarkMode,
        isRightBubbleAlignment: isRightBubbleAlignment ?? this.isRightBubbleAlignment,
        isDateTimeModificationEnabled:
            isDateTimeModificationEnabled ?? this.isDateTimeModificationEnabled,
        showBiometricsDialog: showBiometricsDialog);
  }

  @override
  List<Object?> get props => [
        checkBiometrics,
        isDarkMode,
        isRightBubbleAlignment,
        isDateTimeModificationEnabled,
      ];
}
