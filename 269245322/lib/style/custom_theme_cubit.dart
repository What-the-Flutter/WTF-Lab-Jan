import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared_preferences/sp_settings_helper.dart';
import 'custom_theme_state.dart';
import 'themes.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState());

  void initState() {
    final _sharedPreferencesProvider = SharedPreferencesProvider();
    ThemeData initTheme;
    _sharedPreferencesProvider.getTheme()
        ? initTheme = MyThemes.getThemeFromKey(MyThemeKeys.light)
        : initTheme = MyThemes.getThemeFromKey(MyThemeKeys.dark);
    emit(state.copyWith(theme: initTheme));
  }

  void changeTheme(MyThemeKeys themeKey) {
    emit(state.copyWith(theme: MyThemes.getThemeFromKey(themeKey)));
    final _sharedPreferencesProvider = SharedPreferencesProvider();
    themeKey == MyThemeKeys.light
        ? _sharedPreferencesProvider.changeTheme(true)
        : _sharedPreferencesProvider.changeTheme(false);
  }
}
