import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/data_provider/shared_preferences_provider.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final _prefs = SharedPreferencesProvider();

  ThemeCubit()
      : super(
    ThemeState(
      isLightTheme: true,
      themeData: ThemeData(),
    ),
  );

  void init() {
    emit(
      state.copyWith(
        isLightTheme: _prefs.fetchTheme(),
      ),
    );
    _updateTheme();
  }

  void _updateTheme() async {
    final updatedState =
    state.isLightTheme ? state.lightTheme : state.darkTheme;
    emit(updatedState);
  }

  void changeTheme() {
    _prefs.changeTheme(!_prefs.fetchTheme());
    emit(state.copyWith(isLightTheme: _prefs.fetchTheme()));
    _updateTheme();
  }
}
