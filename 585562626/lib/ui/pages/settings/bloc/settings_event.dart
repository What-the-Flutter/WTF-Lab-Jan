import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SwitchThemeEvent extends SettingsEvent {
  const SwitchThemeEvent();
}

class UpdateBiometricsEvent extends SettingsEvent {
  final bool checkBiometrics;

  const UpdateBiometricsEvent(this.checkBiometrics);

  @override
  List<Object> get props => [checkBiometrics];
}

class InitSettingsEvent extends SettingsEvent {
  const InitSettingsEvent();
}

class UpdateAlignmentEvent extends SettingsEvent {
  const UpdateAlignmentEvent();
}

class UpdateDateTimeModificationEvent extends SettingsEvent {
  const UpdateDateTimeModificationEvent();
}