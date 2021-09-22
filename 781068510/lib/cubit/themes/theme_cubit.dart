import 'package:bloc/bloc.dart';

import '../../database/shared_preferences_helper.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeStates> {
  ThemeCubit() : super(ThemeStates());

  void init() {
    emit(
      state.copyWith(
        isDarkMode: SharedPreferencesProvider().getTheme(),
      ),
    );
    getTheme();
  }

  void getTheme() {
    final update = state.isDarkMode! ? state.darkTheme : state.lightTheme;
    emit(update);
  }

  void changeTheme() {
    emit(
      state.copyWith(isDarkMode: !state.isDarkMode!),
    );
    SharedPreferencesProvider().changeTheme(state.isDarkMode!);
    getTheme();
  }
}
