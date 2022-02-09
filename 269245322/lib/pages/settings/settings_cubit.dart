import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lab_project/style/app_themes.dart';
import 'package:my_lab_project/style/theme_cubit.dart';

import '../../shared_preferences/sp_settings_helper.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(SettingsState(
          textSize: 0,
          aligment: 0,
          theme: 0,
        ));

  final SharedPreferencesProvider _sharedPreferencesProvider =
      SharedPreferencesProvider();

  void initState() {
    final initTextSize = _sharedPreferencesProvider.getTextSize();
    final initAligment = _sharedPreferencesProvider.getALigment();
    final initTheme = _sharedPreferencesProvider.getTheme();

    emit(state.copyWith(
        textSize: initTextSize, aligment: initAligment, theme: initTheme));
  }

  void changeTextSize(int appTextSize) {
    final newTextSize = appTextSize;

    SharedPreferencesProvider.changeTextSize(newTextSize);
    emit(state.copyWith(textSize: newTextSize));
  }

  void changeAligment(int appAligment) {
    final newAligment = appAligment;

    SharedPreferencesProvider.changeALigment(newAligment);
    emit(state.copyWith(aligment: newAligment));
  }

  void changeTheme(int appTheme, ThemeCubit themeCubit) {
    final newTheme = appTheme;

    SharedPreferencesProvider.changeTheme(newTheme);
    emit(state.copyWith(theme: newTheme));
    appTheme == 0
        ? themeCubit.changeTheme(appThemeData[AppTheme.BlueLight]!)
        : themeCubit.changeTheme(appThemeData[AppTheme.BlueDark]!);
  }

  void resetSettings(ThemeCubit themeCubit) {
    SharedPreferencesProvider.resetSettings();
    changeTheme(0, themeCubit);
  }
}
