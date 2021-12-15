import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/settings_repository.dart';
import '../../theme/themes.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsCubit(this.settingsRepository)
      : super(
          SettingsState(
            isCategoryListOpen: true,
            isBiometricAuth: true,
            isLightTheme: true,
            themeData: ThemeData(),
          ),
        );

  void initSettings() {
    _setAbilityChooseCategory();
    _setBiometricAuth();
    emit(
      state.copyWith(
        isLightTheme: settingsRepository.fetchTheme(),
      ),
    );
    _updateTheme();
  }

  void _updateTheme() async {
    final updatedTheme = state.isLightTheme ? lightTheme : darkTheme;
    emit(state.copyWith(themeData: updatedTheme));
  }

  void changeTheme() {
    settingsRepository.changeTheme(!settingsRepository.fetchTheme());
    emit(state.copyWith(isLightTheme: settingsRepository.fetchTheme()));
    _updateTheme();
  }

  void _setAbilityChooseCategory() {
    final isCategoryListOpen = settingsRepository.abilityChooseCategory();
    emit(
      state.copyWith(
        isCategoryListOpen: isCategoryListOpen,
      ),
    );
  }

  void changeAbilityChooseCategory() {
    settingsRepository.changeAbilityChooseCategory(!state.isCategoryListOpen);
    emit(
      state.copyWith(
        isCategoryListOpen: !state.isCategoryListOpen,
      ),
    );
  }

  void _setBiometricAuth() {
    final isBiometricAuth = settingsRepository.biometricAuth();
    emit(
      state.copyWith(
        isBiometricAuth: isBiometricAuth,
      ),
    );
  }

  void changeBiometricAuthAbility() {
    settingsRepository.changeBiometricAuthAbility(!state.isBiometricAuth);
    emit(
      state.copyWith(
        isBiometricAuth: !state.isBiometricAuth,
      ),
    );
  }

  bool isBiometricsAuthAbility() {
    return settingsRepository.biometricAuth();
  }
}
