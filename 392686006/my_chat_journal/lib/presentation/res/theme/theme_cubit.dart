import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/shared_preferences.dart';
import 'theme.dart';
class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(SharedPreferencesProvider.isDarkMode ? dark : light);

  bool get isDarkMode => state == dark;

  void changeTheme() {
    emit(state == light ? dark : light);
    SharedPreferencesProvider.saveThemeMode(state == dark ? true : false);
  }
}