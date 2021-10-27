import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/themes.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
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
            fontSize: 15,
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
  }

  void setSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _setTheme(prefs);
    _setFontSize(prefs);
    _setBiometricsUsage(prefs);
    _setCategoryPanelVisibility(prefs);
    _setCustomDateUsage(prefs);
    _setMessageAlignment(prefs);
    _setDateAlignment(prefs);
  }

  void _setTheme(SharedPreferences prefs) {
    final _savedTheme = prefs.getString('theme') ?? 'light';
    final _themeData = (_savedTheme == 'light' ? lightTheme : darkTheme);
    emit(
      state.copyWith(theme: _themeData),
    );
  }

  void _setFontSize(SharedPreferences prefs) {
    final _fontSize = prefs.getInt('fontSize') ?? state.mediumFontSize;
    emit(
      state.copyWith(fontSize: _fontSize),
    );
  }

  void _setBiometricsUsage(SharedPreferences prefs) {
    final _useBiometrics = prefs.getBool('useBiometrics') ?? false;
    emit(
      state.copyWith(useBiometrics: _useBiometrics),
    );
  }

  void _setCategoryPanelVisibility(SharedPreferences prefs) {
    final _categoryPanelVisibility =
        prefs.getBool('categoryPanelVisibility') ?? true;
    emit(
      state.copyWith(isCategoryPanelVisible: _categoryPanelVisibility),
    );
  }

  void _setCustomDateUsage(SharedPreferences prefs) {
    final _customDateUsage = prefs.getBool('isCustomDateUsed') ?? true;
    emit(
      state.copyWith(isCustomDateUsed: _customDateUsage),
    );
  }

  void _setMessageAlignment(SharedPreferences prefs) {
    final _savedMessageAlignment =
        prefs.getString('messageAlignment') ?? 'left';
    final _messageAlignment = (_savedMessageAlignment == 'left'
        ? Alignment.centerLeft
        : Alignment.centerRight);
    emit(
      state.copyWith(
        messageAlignment: _messageAlignment,
        isMessageSwitchOn: _messageAlignment == Alignment.centerRight,
      ),
    );
  }

  void _setDateAlignment(SharedPreferences prefs) {
    final _savedDateAlignment = prefs.getString('dateAlignment') ?? 'left';
    final _dateAlignment = (_savedDateAlignment == 'left'
        ? Alignment.centerLeft
        : Alignment.center);
    emit(
      state.copyWith(
          dateAlignment: _dateAlignment,
          isDateSwitchOn: _dateAlignment == Alignment.center),
    );
  }

  Future<void> changeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final _savedTheme;
    final _themeData;
    if (state.theme == lightTheme) {
      _themeData = darkTheme;
      _savedTheme = 'dark';
    } else {
      _themeData = lightTheme;
      _savedTheme = 'light';
    }
    emit(
      state.copyWith(theme: _themeData),
    );
    prefs.setString('theme', _savedTheme);
  }

  void changeFontSize(int chosenFontSize) async {
    final prefs = await SharedPreferences.getInstance();
    emit(
      state.copyWith(fontSize: chosenFontSize),
    );
    prefs.setInt('fontSize', chosenFontSize);
  }

  Future<void> changeCategoryPanelVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    emit(
      state.copyWith(isCategoryPanelVisible: !state.isCategoryPanelVisible),
    );
    prefs.setBool('categoryPanelVisibility', state.isCategoryPanelVisible);
  }

  Future<void> changeBiometricsUsage() async {
    final prefs = await SharedPreferences.getInstance();
    emit(
      state.copyWith(useBiometrics: !state.useBiometrics),
    );
    prefs.setBool('useBiometrics', state.useBiometrics);
  }

  Future<void> changeCustomDateUsage() async {
    final prefs = await SharedPreferences.getInstance();
    emit(
      state.copyWith(isCustomDateUsed: !state.isCustomDateUsed),
    );
    prefs.setBool('isCustomDateUsed', state.isCustomDateUsed);
  }

  Future<void> changeMessageAlignment() async {
    final prefs = await SharedPreferences.getInstance();
    final _savedMessageAlignment;
    if (state.messageAlignment == Alignment.centerLeft) {
      _savedMessageAlignment = 'right';
      emit(
        state.copyWith(
          messageAlignment: Alignment.centerRight,
          isMessageSwitchOn: true,
        ),
      );
    } else {
      _savedMessageAlignment = 'left';
      emit(
        state.copyWith(
          messageAlignment: Alignment.centerLeft,
          isMessageSwitchOn: false,
        ),
      );
    }
    prefs.setString('messageAlignment', _savedMessageAlignment);
  }

  Future<void> changeDateAlignment() async {
    final prefs = await SharedPreferences.getInstance();
    final _savedDateAlignment;
    if (state.dateAlignment == Alignment.centerLeft) {
      _savedDateAlignment = 'center';
      emit(
        state.copyWith(
          dateAlignment: Alignment.center,
          isDateSwitchOn: true,
        ),
      );
    } else {
      _savedDateAlignment = 'left';
      emit(
        state.copyWith(
          dateAlignment: Alignment.centerLeft,
          isDateSwitchOn: false,
        ),
      );
    }
    prefs.setString('dateAlignment', _savedDateAlignment);
  }

  Future<bool> useBiometrics() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('useBiometrics') ?? false;
  }

  void onShareData() async {
    await Share.share(
        'Sorry, you can\'t download this app, but you can look at sleepy pig https://vk.com/video-167127847_456274642');
  }
}
