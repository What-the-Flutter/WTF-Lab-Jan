import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'thememode_state.dart';

class ThememodeCubit extends Cubit<ThememodeState> {
  final SharedPreferences preferences;

  ThememodeCubit(ThemeMode themeMode, {this.preferences})
      : super(ThememodeState(themeMode: themeMode));

  void switchThemeMode() async {
    if (state.themeMode == ThemeMode.light) {
      preferences?.setString('themeMode', 'dark');
      emit(ThememodeState(themeMode: ThemeMode.dark));
    } else if (state.themeMode == ThemeMode.dark) {
      preferences?.setString('themeMode', 'light');
      emit(ThememodeState(themeMode: ThemeMode.light));
    }
  }
}
