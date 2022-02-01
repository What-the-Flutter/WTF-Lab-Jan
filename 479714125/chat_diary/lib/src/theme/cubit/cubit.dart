import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(isDarkTheme: false));

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkTheme = (prefs.getBool('isDarkTheme') ?? false);
    emit(state.copyWith(isDarkTheme: isDarkTheme));
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', !state.isDarkTheme);
    emit(state.copyWith(isDarkTheme: !state.isDarkTheme));
  }
}
