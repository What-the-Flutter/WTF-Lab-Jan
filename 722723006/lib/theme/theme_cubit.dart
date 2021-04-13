import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/shared_preferences_provider.dart';
import 'theme_states.dart';

class ThemeCubit extends Cubit<ThemeStates> {
  ThemeCubit() : super(ThemeStates());
  final _prefs = SharedPreferencesProvider();

  void _updateTheme() async {
    final updatedState =
        state.isLightTheme ? state.lightTheme : state.darkTheme;
    emit(updatedState);
  }

  void init() async {
    await emit(state.copyWith(isLightTheme: _prefs.fetchTheme()));
    initTextTheme(_prefs.fetchFontSizeIndex());
    emit(state.copyWith(textTheme: state.textTheme));
    _updateTheme();
  }

  void initTextTheme(int fontSizeIndex) {
    switch (fontSizeIndex) {
      case 0:
        emit(state.copyWith(textTheme: ThemeStates.smallTextTheme));
        break;
      case 1:
        emit(state.copyWith(textTheme: ThemeStates.defaultTextTheme));
        break;
      case 2:
        emit(state.copyWith(textTheme: ThemeStates.largeTextTheme));
        break;
    }
  }

  void setLightTheme() async {
    emit(state.copyWith(isLightTheme: true));
    _prefs.changeTheme(state.isLightTheme);
    _updateTheme();
  }

  void changeTextTheme(int index) async {
    _prefs.changeFontSizeIndex(index);
    initTextTheme(index);
    emit(state.copyWith(textTheme: state.textTheme));
    _updateTheme();
  }

  void changeTheme() async {
    emit(state.copyWith(isLightTheme: !state.isLightTheme));
    _prefs.changeTheme(state.isLightTheme);
    _updateTheme();
  }
}
