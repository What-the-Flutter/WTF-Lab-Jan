import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/shared_preferences_provider.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final _prefs = SharedPreferencesProvider();

  ThemeCubit()
      : super(ThemeState(
          true,
          ThemeData(),
    ThemeState.smallTextTheme,
        ));

  void init(){
    initTextTheme(_prefs.fetchFontSizeIndex());
    emit(
      state.copyWith(
        isLight: _prefs.fetchTheme(),
        textTheme: ThemeState.largeTextTheme,
      ),
    );
    _updateTheme();
  }

  void _updateTheme() async {
    final updatedState = state.isLight ? state.lightTheme : state.darkTheme;
    emit(updatedState);
  }

  void changeTheme() {
    _prefs.changeTheme(!_prefs.fetchTheme());
    emit(state.copyWith(isLight: _prefs.fetchTheme()));
    _updateTheme();
  }

  void initTextTheme(int fontSizeIndex) {
    switch (fontSizeIndex) {
      case 0:
        emit(state.copyWith(textTheme: ThemeState.smallTextTheme));
        break;
      case 1:
        emit(state.copyWith(textTheme: ThemeState.defaultTextTheme));
        break;
      case 2:
        emit(state.copyWith(textTheme: ThemeState.largeTextTheme));
        break;
    }
  }

  void changeTextTheme(int index) async {
    _prefs.changeFontSizeIndex(index);
    initTextTheme(index);
    emit(state.copyWith(textTheme: state.textTheme));
    _updateTheme();
  }
}
