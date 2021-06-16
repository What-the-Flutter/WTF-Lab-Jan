import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/theme.dart';
import '../services/shared_prefs.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() :
        super(
          ThemeChangingInitial(
            theme(MySharedPreferences.sharedPrefs.theme),
          ),
        );

  void changeTheme(bool isDark) {
    MySharedPreferences.sharedPrefs.setTheme(isDark);
    if (!isDark) {
      emit(state.copyWith(themes: Themes.light));
    } else {
      emit(state.copyWith(themes: Themes.dark));
    }
  }
}
