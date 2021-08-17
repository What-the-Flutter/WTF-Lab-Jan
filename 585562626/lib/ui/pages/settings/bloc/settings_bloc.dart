import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../repository/preferences_provider.dart';
import 'bloc.dart';

enum BiometricsCheck { enabled, disabled, notAvailable }
enum SettingsFontSize { small, medium, normal, big, large }

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final PreferencesProvider preferencesProvider;

  SettingsBloc({
    required this.preferencesProvider,
    required SettingsState initialState,
  }) : super(initialState);

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is InitSettingsEvent) {
      final _localAuthentication = LocalAuthentication();
      final canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      yield await _init(canCheckBiometrics);
    } else if (state is MainSettingsState) {
      final currentState = state as MainSettingsState;
      if (event is UpdateBiometricsEvent) {
        preferencesProvider.saveBiometricsMode(event.checkBiometrics);
        yield currentState.copyWith(
          checkBiometrics:
              event.checkBiometrics ? BiometricsCheck.enabled : BiometricsCheck.disabled,
        );
      } else if (event is SwitchThemeEvent) {
        final newMode = !currentState.isDarkMode;
        preferencesProvider.saveTheme(newMode);
        yield currentState.copyWith(isDarkMode: newMode);
      } else if (event is UpdateAlignmentEvent) {
        final newMode = !currentState.isRightBubbleAlignment;
        preferencesProvider.saveBubbleAlignment(newMode);
        yield currentState.copyWith(isRightBubbleAlignment: newMode);
      } else if (event is UpdateDateTimeModificationEvent) {
        final newMode = !currentState.isDateTimeModificationEnabled;
        preferencesProvider.saveDateTimeModification(newMode);
        yield currentState.copyWith(isDateTimeModificationEnabled: newMode);
      } else if (event is UpdateFontSizeEvent) {
        preferencesProvider.saveFontSize(event.fontSize.index);
        yield currentState.copyWith(fontSize: event.fontSize);
      } else if (event is ClearSettingsEvent) {
        preferencesProvider.resetAll();
        yield await _init(currentState.canCheckBiometrics);
      }
    }
  }

  Future<SettingsState> _init(bool canCheckBiometrics) async {
    final isBiometricsEnabled = await preferencesProvider.biometricsLockEnabled();
    final isDarkMode = await preferencesProvider.isDarkTheme();
    final isLeftAlignment = await preferencesProvider.bubbleAlignment();
    final isDateTimeModificationEnabled = await preferencesProvider.dateTimeModificationEnabled();
    final fontSizeIndex = await preferencesProvider.fontSize();
    return MainSettingsState(
      showBiometricsDialog: isBiometricsEnabled,
      isRightBubbleAlignment: isLeftAlignment,
      isDateTimeModificationEnabled: isDateTimeModificationEnabled,
      isDarkMode: isDarkMode,
      canCheckBiometrics: canCheckBiometrics,
      checkBiometrics: canCheckBiometrics
          ? (isBiometricsEnabled ? BiometricsCheck.enabled : BiometricsCheck.disabled)
          : BiometricsCheck.notAvailable,
      fontSize: SettingsFontSize.values[fontSizeIndex ?? SettingsFontSize.normal.index],
    );
  }
}
