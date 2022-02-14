import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared_preferences/sp_settings_helper.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState());

  void initState() {
    changeTheme(
      SharedPreferencesProvider.getThemeData(),
    );
  }

  void changeTheme(ThemeData themeData) {
    emit(
      state.copyWith(themeData: themeData),
    );
  }
}
