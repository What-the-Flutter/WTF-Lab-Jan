import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../util/shared_preferences_provider.dart';

part 'theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(
          ThemeState(
            SharedPreferencesProvider().fetchTheme(),
          ),
        );

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is SetTheme) {
      yield state.copyWith(
        isLight: SharedPreferencesProvider().fetchTheme(),
      );
      print('${state.isLight}');
    } else if (event is ChangeThemeEvent) {
      SharedPreferencesProvider().changeTheme(
        !SharedPreferencesProvider().fetchTheme(),
      );
      yield state.copyWith(
        isLight: SharedPreferencesProvider().fetchTheme(),
      );
    }
  }
}
