part of 'settings_cubit.dart';

enum SettingsStates {
  initial,
  bubbleAlignment,
  centerDateBubble,
  modifyDate,
  biometricAuth
}

class SettingsState extends Equatable {
  final SettingsStates settingsStates;
  final bool isBubbleAlignment;
  final bool isCenterDateBubble;
  final bool isModifiedDate;
  final bool? isBiometricAuth;

  const SettingsState(this.isBubbleAlignment, this.isCenterDateBubble,
      this.isModifiedDate, this.isBiometricAuth, this.settingsStates);

  SettingsState copyWith({
    final bool? isBubbleAlignment,
    final bool? isCenterDateBubble,
    final bool? isModifiedDate,
    final bool? isBiometricAuth,
    final SettingsStates? settingsStates,
  }) {
    return SettingsState(
      isBubbleAlignment ?? this.isBubbleAlignment,
      isCenterDateBubble ?? this.isCenterDateBubble,
      isModifiedDate ?? this.isModifiedDate,
      isBiometricAuth ?? this.isBiometricAuth,
      settingsStates ?? this.settingsStates,
    );
  }

  @override
  List<Object?> get props =>
      [isBubbleAlignment, isCenterDateBubble, isModifiedDate, isBiometricAuth];
}
