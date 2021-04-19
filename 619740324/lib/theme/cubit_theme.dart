import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/shared_preferences_provider.dart';

import 'states_theme.dart';

class CubitTheme extends Cubit<StatesTheme> {
  CubitTheme() : super(StatesTheme());

  void init() {
    emit(
        state.copyWith(isLightTheme: SharedPreferencesProvider().fetchTheme()));
    setTextTheme(SharedPreferencesProvider().fetchFontSize());
    updateTheme();
  }

  void setTextTheme(int fontSizeIndex) {
    switch (fontSizeIndex) {
      case 1:
        emit(state.copyWith(textTheme: StatesTheme.smallTextTheme));
        break;
      case 2:
        emit(state.copyWith(textTheme: StatesTheme.defaultTextTheme));
        break;
      case 3:
        emit(state.copyWith(textTheme: StatesTheme.largeTextTheme));
        break;
    }
    SharedPreferencesProvider().changeFontSize(fontSizeIndex);
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
