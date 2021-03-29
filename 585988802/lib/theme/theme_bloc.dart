import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../custom_shared_preferences/custom_shared_preferences.dart';

import 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.light);

  final CustomSharedPreferences _customSharedPreferences =
      CustomSharedPreferences();

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

  Stream<ThemeMode> _mapInitThemeEventToState() async* {
    final isCurrentThemeModeDark =
        await _customSharedPreferences.sharedPrefInitTheme();
    yield isCurrentThemeModeDark == true ? ThemeMode.dark : ThemeMode.light;
  }

  Stream<ThemeMode> _mapChangeThemeEventToState() async* {
    final themeMode =
        state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _customSharedPreferences.sharedPrefChangeTheme(themeMode);
    yield themeMode;
  }

  Stream<ThemeMode> _mapResetThemeEventToState() async* {
    _customSharedPreferences.sharedPrefResetTheme();
    yield ThemeMode.light;
  }
}
