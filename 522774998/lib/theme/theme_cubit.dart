import 'package:flutter_bloc/flutter_bloc.dart';
import '../preferences.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  bool _isLightTheme = true;
  final _preferences = Preferences();

  ThemeCubit() : super(ThemeState.darkTheme);

  void _applyTheme() async {
    final updatedState =
        _isLightTheme ? ThemeState.lightTheme : ThemeState.darkTheme;
    emit(updatedState);
  }

  void initialize() async {
    _isLightTheme = _preferences.fetchTheme();
    _applyTheme();
  }

  void changeTheme() async {
    _isLightTheme = !_isLightTheme;
    _preferences.saveTheme(_isLightTheme);
    _applyTheme();
  }
}
