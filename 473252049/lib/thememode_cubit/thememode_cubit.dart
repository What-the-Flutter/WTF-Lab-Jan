import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'thememode_state.dart';

class ThememodeCubit extends Cubit<ThememodeState> {
  ThememodeCubit(ThemeMode themeMode)
      : super(ThememodeState(themeMode: themeMode));

  void switchThemeMode() {
    if (state.themeMode == ThemeMode.light) {
      emit(ThememodeState(themeMode: ThemeMode.dark));
    } else if (state.themeMode == ThemeMode.dark) {
      emit(ThememodeState(themeMode: ThemeMode.light));
    }
  }
}
