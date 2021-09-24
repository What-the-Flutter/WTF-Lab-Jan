import 'package:bloc/bloc.dart';

import 'color_theme_state.dart';
import 'data/preferences_access.dart';

class ColorThemeCubit extends Cubit<ColorThemeState> {
  bool _usingLightTheme = true;
  final _preferencesAccess = PreferencesAccess();

  ColorThemeCubit() : super(ColorThemeState.darkTheme);

  void _applyTheme() async {
    final updatedState = _usingLightTheme ? ColorThemeState.lightTheme : ColorThemeState.darkTheme;
    emit(updatedState);
  }

  void initialize() async {
    _usingLightTheme = _preferencesAccess.fetchTheme();
    _applyTheme();
  }

  void changeTheme() async {
    _usingLightTheme = !_usingLightTheme;
    _preferencesAccess.saveTheme(_usingLightTheme);
    _applyTheme();
  }
}
