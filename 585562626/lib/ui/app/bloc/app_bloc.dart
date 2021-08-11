import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/themes.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {

  static AppState _init() {
    final brightness = SchedulerBinding.instance?.window.platformBrightness;
    final darkModeOn = brightness == Brightness.dark;
    final theme = darkModeOn ? darkTheme : lightTheme;
    final initialState = AppState(theme, darkModeOn);
    return initialState;
  }

  AppBloc() : super(_init());

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is SwitchThemeEvent) {
      final theme;
      if (state.theme == lightTheme) {
        theme = darkTheme;
      } else {
        theme = lightTheme;
      }
      final isDarkMode = theme == darkTheme;
      yield AppState(theme, isDarkMode);
    }
  }
}
