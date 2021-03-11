import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  static const _keyThemeMode = 'themeMode';

  ThemeBloc() : super(ThemeMode.light);

  @override
  Stream<ThemeMode> mapEventToState(ThemeEvent event) async* {
    if (event is ChangeThemeEvent) {
      yield* _mapChangeThemeEventToState();
    } else if (event is InitThemeEvent) {
      yield* _mapInitThemeEventToState();
    } else if (event is ResetThemeEvent) {
      yield* _mapResetThemeEventToState();
    }
  }

  Stream<ThemeMode> _mapChangeThemeEventToState() async* {
    final themeMode =
        state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_keyThemeMode, themeMode == ThemeMode.dark);
    yield themeMode;
  }

  Stream<ThemeMode> _mapInitThemeEventToState() async* {
    final pref = await SharedPreferences.getInstance();
    final isCurrentThemeModeDark = await pref.getBool(_keyThemeMode) ?? false;
    yield isCurrentThemeModeDark == true ? ThemeMode.dark : ThemeMode.light;
  }

  Stream<ThemeMode> _mapResetThemeEventToState() async* {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_keyThemeMode, false);
    yield ThemeMode.light;
  }
}
