import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/theme/theme_color.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(SettingsState(
          theme: lightTheme,
        ));

  Future<void> initSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final changedTheme = prefs.getString('theme') ?? 'light';
    emit(
      state.copyWith(
        themeData: changedTheme,
        theme: changedTheme == 'light' ? lightTheme : darkTheme,
      ),
    );
  }

  Future<void> changeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final String changedTheme;
    if (state.themeData == 'light') {
      changedTheme = 'dark';
      emit(state.copyWith(theme: darkTheme, themeData: changedTheme));
    } else {
      changedTheme = 'light';
      emit(state.copyWith(theme: lightTheme, themeData: changedTheme));
    }
    prefs.setString('theme', changedTheme);
  }
}
