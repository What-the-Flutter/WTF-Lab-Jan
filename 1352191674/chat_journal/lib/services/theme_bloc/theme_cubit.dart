import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../shared_preferences_provider.dart';

part 'theme_state.dart';

//переписывать на кьюбит
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(
          ThemeState(
            SharedPreferencesProvider().fetchTheme(),
          ),
        );

  void changeTheme() {
    SharedPreferencesProvider().changeTheme(
      !SharedPreferencesProvider().fetchTheme(),
      );
    emit(state.copyWith(isLight: SharedPreferencesProvider().fetchTheme()));
  }
}
