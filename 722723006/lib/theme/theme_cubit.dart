import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/shared_preferences_provider.dart';
import 'theme_states.dart';

class ThemeCubit extends Cubit<ThemeStates> {
  ThemeCubit() : super(ThemeStates());
  final _prefs = SharedPreferencesProvider();

  void _applyTheme() async {
    final updatedState =
        state.isLightTheme ? state.lightTheme : state.darkTheme;
    emit(updatedState);
  }

  void initialize() async {
    state.isLightTheme = _prefs.fetchTheme();
    checkFontSizeIndex();
    emit(state.copyWith(textTheme: state.textTheme));
    _applyTheme();
  }

  void checkFontSizeIndex() {
    if (_prefs.fetchFontSizeIndex() == 1) {
      state.textTheme = ThemeStates.defaultTextTheme;
    } else if (_prefs.fetchFontSizeIndex() == 0) {
      state.textTheme = ThemeStates.smallTextTheme;
    } else {
      state.textTheme = ThemeStates.largeTextTheme;
    }
  }

  void setLightTheme() async {
    state.isLightTheme = true;
    _prefs.changeTheme(state.isLightTheme);
    _applyTheme();
  }

  void changeTextTheme(int index) async {
    _prefs.changeFontSizeIndex(index);
    checkFontSizeIndex();
    emit(state.copyWith(textTheme: state.textTheme));
    _applyTheme();
  }

  void changeTheme() async {
    state.isLightTheme = !state.isLightTheme;
    _prefs.changeTheme(state.isLightTheme);
    _applyTheme();
  }
}
