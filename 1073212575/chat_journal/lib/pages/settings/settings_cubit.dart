import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          ),
        );
  var _savedTheme;
  var _themeData;

  var _useBiometrics;

  var _categoryPanelVisibility;

  var _customDateUsage;

  var _savedMessageAlignment;
  var _messageAlignment;

  var _savedDateAlignment;
  var _dateAlignment;

  void setSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _setTheme(prefs);
    _setBiometricsUsage(prefs);
    _setCategoryPanelVisibility(prefs);
    _setCustomDateUsage(prefs);
    _setMessageAlignment(prefs);
    _setDateAlignment(prefs);
  }

  void _setTheme(SharedPreferences prefs) {
    _savedTheme = prefs.getString('theme') ?? 'light';
    _themeData = (_savedTheme == 'light' ? lightTheme : darkTheme);
    emit(
      state.copyWith(theme: _themeData),
    );
  }

  void _setBiometricsUsage(SharedPreferences prefs) {
    _useBiometrics = prefs.getBool('useBiometrics') ?? false;
    emit(
      state.copyWith(useBiometrics: _useBiometrics),
    );
  }

  void _setCategoryPanelVisibility(SharedPreferences prefs) {
    _categoryPanelVisibility = prefs.getBool('categoryPanelVisibility') ?? true;
    emit(
      state.copyWith(isCategoryPanelVisible: _categoryPanelVisibility),
    );
  }

  void _setCustomDateUsage(SharedPreferences prefs) {
    _customDateUsage = prefs.getBool('isCustomDateUsed') ?? true;
    emit(
      state.copyWith(isCustomDateUsed: _customDateUsage),
    );
  }

  void _setMessageAlignment(SharedPreferences prefs) {
    _savedMessageAlignment = prefs.getString('messageAlignment') ?? 'left';
    _messageAlignment = (_savedMessageAlignment == 'left'
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
    _savedDateAlignment = prefs.getString('dateAlignment') ?? 'left';
    _dateAlignment = (_savedDateAlignment == 'left'
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
    if (_themeData == lightTheme) {
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
}
