import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/shared_preferences_provider.dart';

import 'states_theme.dart';

class CubitTheme extends Cubit<StatesTheme> {
  CubitTheme() : super(StatesTheme());

  void init() {
    state.isLightTheme = SharedPreferencesProvider().fetchTheme();
    updateTheme();
  }

  void updateTheme() {
    final update = state.isLightTheme ? state.lightTheme : state.darkTheme;
    emit(update);
  }

  void changeTheme() {
    emit(state.copyWith(isLightTheme: !state.isLightTheme));
    SharedPreferencesProvider().changeTheme(state.isLightTheme);
    updateTheme();
  }
}
