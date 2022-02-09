import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lab_project/shared_preferences/sp_settings_helper.dart';
import 'package:my_lab_project/style/app_themes.dart';
import 'package:my_lab_project/style/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState());

  void initState() {
    emit(state.copyWith(
        themeData: appThemeData[SharedPreferencesProvider.getEnumTheme()]!));
  }

  void changeTheme(ThemeData themeData) {
    emit(state.copyWith(themeData: themeData));
  }
}
