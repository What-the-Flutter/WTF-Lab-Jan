import 'package:flutter_bloc/flutter_bloc.dart';

import 'states_theme.dart';

class CubitTheme extends Cubit<StatesTheme> {
  CubitTheme() : super(StatesTheme());

  void init() {
    updateTheme();
  }

  void updateTheme() {
    final update = state.isLightTheme ? state.lightTheme : state.darkTheme;
    emit(update);
  }

  void changeTheme() {
    emit(state.copyWith(isLightTheme: !state.isLightTheme));
    updateTheme();
  }
}
