import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../utils/shared_preferences_provider.dart';
import 'theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit()
      : super(SharedPreferencesProvider.isDarkMode ? darkTheme : lightTheme);

  bool get isDarkMode => state == darkTheme;

  void changeTheme() {
    emit(state == lightTheme ? darkTheme : lightTheme);
    SharedPreferencesProvider.saveThemeMode(state == darkTheme ? true : false);
  }
}
