import 'package:bloc/bloc.dart';
import 'package:chat_journal/repository/settings_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/themes.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsCubit(this.settingsRepository)
      : super(
          SettingsState(
            theme: lightTheme,
            isCategoryPanelVisible: true,
            isCustomDateUsed: true,
            isMessageSwitchOn: false,
            isDateSwitchOn: false,
            useBiometrics: false,
            messageAlignment: Alignment.centerLeft,
            dateAlignment: Alignment.centerLeft,
            smallFontSize: 14,
            mediumFontSize: 16,
            largeFontSize: 18,
            fontSize: 16,
          ),
        );

  void resetSettings() {
    emit(
      state.copyWith(
        theme: lightTheme,
        isCategoryPanelVisible: true,
        isCustomDateUsed: true,
        isMessageSwitchOn: false,
        isDateSwitchOn: false,
        useBiometrics: false,
        messageAlignment: Alignment.centerLeft,
        dateAlignment: Alignment.centerLeft,
        smallFontSize: 14,
        mediumFontSize: 16,
        largeFontSize: 18,
        fontSize: state.mediumFontSize,
      ),
    );
    settingsRepository.resetSettings();
  }

  void setSettings() {
    _setTheme();
    _setFontSize();
    _setBiometricsUsage();
    _setCategoryPanelVisibility();
    _setCustomDateUsage();
    _setMessageAlignment();
    _setDateAlignment();
  }

  Future<void> _setTheme() async {
    final savedTheme = await settingsRepository.theme();
    final themeData = (savedTheme == 'light' ? lightTheme : darkTheme);
    emit(
      state.copyWith(theme: themeData),
    );
  }

  void _setFontSize() async {
    emit(
      state.copyWith(
        fontSize: await settingsRepository.fontSize(),
      ),
    );
  }

  void _setBiometricsUsage() async {
    emit(
      state.copyWith(
        useBiometrics: await settingsRepository.biometricsUsage(),
      ),
    );
  }

  void _setCategoryPanelVisibility() async {
    final isCategoryPanelVisible =
        await settingsRepository.categoryPanelVisibility();
    emit(
      state.copyWith(
        isCategoryPanelVisible: isCategoryPanelVisible,
      ),
    );
  }

  void _setCustomDateUsage() async {
    emit(
      state.copyWith(
        isCustomDateUsed: await settingsRepository.customDateUsage(),
      ),
    );
  }

  void _setMessageAlignment() async {
    final savedMessageAlignment = await settingsRepository.messageAlignment();
    final messageAlignment = (savedMessageAlignment == 'left'
        ? Alignment.centerLeft
        : Alignment.centerRight);
    emit(
      state.copyWith(
        messageAlignment: messageAlignment,
        isMessageSwitchOn: messageAlignment == Alignment.centerRight,
      ),
    );
  }

  void _setDateAlignment() async {
    final dateAlignment = (await settingsRepository.dateAlignment() == 'left'
        ? Alignment.centerLeft
        : Alignment.center);
    emit(
      state.copyWith(
          dateAlignment: dateAlignment,
          isDateSwitchOn: state.dateAlignment == Alignment.center),
    );
  }

  void changeTheme() {
    final savedTheme;
    final themeData;
    if (state.theme == lightTheme) {
      themeData = darkTheme;
      savedTheme = 'dark';
    } else {
      themeData = lightTheme;
      savedTheme = 'light';
    }
    emit(
      state.copyWith(theme: themeData),
    );
    settingsRepository.changeTheme(savedTheme);
  }

  void changeFontSize(int chosenFontSize) {
    emit(
      state.copyWith(fontSize: chosenFontSize),
    );
    settingsRepository.changeFontSize(chosenFontSize);
  }

  void changeCategoryPanelVisibility() {
    emit(
      state.copyWith(isCategoryPanelVisible: !state.isCategoryPanelVisible),
    );
    settingsRepository
        .changeCategoryPanelVisibility(state.isCategoryPanelVisible);
  }

  void changeBiometricsUsage() {
    emit(
      state.copyWith(useBiometrics: !state.useBiometrics),
    );
    settingsRepository.changeBiometricsUsage(state.useBiometrics);
  }

  void changeCustomDateUsage() {
    emit(
      state.copyWith(isCustomDateUsed: !state.isCustomDateUsed),
    );
    settingsRepository.changeCustomDateUsage(state.isCustomDateUsed);
  }

  void changeMessageAlignment() {
    final messageAlignment;
    if (state.messageAlignment == Alignment.centerLeft) {
      messageAlignment = 'right';
      emit(
        state.copyWith(
          messageAlignment: Alignment.centerRight,
          isMessageSwitchOn: true,
        ),
      );
    } else {
      messageAlignment = 'left';
      emit(
        state.copyWith(
          messageAlignment: Alignment.centerLeft,
          isMessageSwitchOn: false,
        ),
      );
    }
    settingsRepository.changeMessageAlignment(messageAlignment);
  }

  void changeDateAlignment() {
    final savedDateAlignment;
    if (state.dateAlignment == Alignment.centerLeft) {
      savedDateAlignment = 'center';
      emit(
        state.copyWith(
          dateAlignment: Alignment.center,
          isDateSwitchOn: true,
        ),
      );
    } else {
      savedDateAlignment = 'left';
      emit(
        state.copyWith(
          dateAlignment: Alignment.centerLeft,
          isDateSwitchOn: false,
        ),
      );
    }
    settingsRepository.changeDateAlignment(savedDateAlignment);
  }

  bool useBiometrics() {
    return settingsRepository.useBiometrics();
  }

  void onShareData() async {
    await Share.share(
        'Sorry, you can\'t download this app, but you can look at sleepy pig https://vk.com/video-167127847_456274642');
  }
}
