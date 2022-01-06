import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';

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
            isRightBubbleAlignment: true,
            smallFontSize: 12,
            mediumFontSize: 16,
            largeFontSize: 18,
            chosenFontSize: 16,
            themeData: ThemeData(),
          ),
        );

  void initSettings() {
    _setAbilityChooseCategory();
    _setBiometricAuth();
    _updateTheme();
  }

  Future<void> share() async {
    await FlutterShare.share(
      title: 'Chat Journal',
      text:
          'Keep track of your life with Chat Journal, a simple and elegant chat-based'
          ' journal/notes application that makes journaling/note-taking fun, '
          'easy, quick and effortless.',
      linkUrl:
          'https://play.google.com/store/apps/details?id=com.agiletelescope.chatjournal',
    );
  }

  void resetAllSettings() {
    settingsRepository.resetAllSettings();
    emit(
      state.copyWith(
        isCategoryListOpen: true,
        isBiometricAuth: true,
        isLightTheme: true,
        isRightBubbleAlignment: true,
        chosenFontSize: state.mediumFontSize,
        themeData: lightTheme,
      ),
    );
  }

  void _updateTheme() async {
    final updatedTheme = state.isLightTheme ? lightTheme : darkTheme;
    emit(
      state.copyWith(themeData: updatedTheme),
    );
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

  void _isRightBubbleAlignment() {
    final isRightBubbleAlignment = settingsRepository.isRightBubbleAlignment();
    emit(
      state.copyWith(
        isRightBubbleAlignment: isRightBubbleAlignment,
      ),
    );
  }

  void changeBubbleAlignment() {
    settingsRepository.changeBubbleAlignment(!state.isRightBubbleAlignment);
    emit(
      state.copyWith(
        isRightBubbleAlignment: !state.isRightBubbleAlignment,
      ),
    );
  }

  void setFontSize() {
    final fontSize = settingsRepository.fetchFontSize();
    emit(
      state.copyWith(
        chosenFontSize: fontSize,
      ),
    );
  }

  void changeFontSize(double fontSize) {
    settingsRepository.changeFontSize(fontSize);
    emit(
      state.copyWith(
        chosenFontSize: fontSize,
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
