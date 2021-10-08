import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences preferences;
  ThemeCubit(ThemeMode themeMode, {required this.preferences})
      : super(
          ThemeState(
            themeMode: themeMode,
          ),
        );
  void changeTheme() async {
    if (state.themeMode == ThemeMode.light) {
      preferences.setString(
        'themeMode',
        'dark',
      );
      emit(
        ThemeState(themeMode: ThemeMode.dark),
      );
    } else if (state.themeMode == ThemeMode.dark) {
      preferences.setString(
        'themeMode',
        'light',
      );
      emit(
        ThemeState(themeMode: ThemeMode.light),
      );
    }
  }
}
