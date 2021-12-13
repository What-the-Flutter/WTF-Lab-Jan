import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(bool isDarkTheme) : super(ThemeState(isDarkTheme: isDarkTheme));

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', !state.isDarkTheme);
    emit(state.copyWith(isDarkTheme: !state.isDarkTheme));
  }
}
