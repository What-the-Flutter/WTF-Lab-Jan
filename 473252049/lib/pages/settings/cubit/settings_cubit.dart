import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences preferences;

  SettingsCubit({@required this.preferences})
      : super(
          SettingsState(
            themeMode: _themeModeFromString(
              preferences.getString('themeMode'),
            ),
          ),
        );

  void switchThemeMode() async {
    if (state.themeMode == ThemeMode.light) {
      preferences?.setString('themeMode', 'dark');
      emit(state.copyWith(themeMode: ThemeMode.dark));
    } else if (state.themeMode == ThemeMode.dark) {
      preferences?.setString('themeMode', 'light');
      emit(state.copyWith(themeMode: ThemeMode.light));
    }
  }

  static ThemeMode _themeModeFromString(String string) {
    switch (string) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.light;
    }
  }
}
