import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme_state.dart';

class AppThemeCubit extends Cubit<AppThemeState> {
  bool _usingLightTheme = true;

  AppThemeCubit() : super(AppThemeState.darkTheme);

  void _fetchTheme() async {
    var prefs = await SharedPreferences.getInstance();
    _usingLightTheme = prefs.getBool('usingLightTheme') ?? true;
  }

  void _saveTheme() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('usingLightTheme', _usingLightTheme);
  }

  void _applyTheme() async {
    final updatedState =
        _usingLightTheme ? AppThemeState.lightTheme : AppThemeState.darkTheme;
    emit(updatedState);
  }

  void initialize() async {
    _fetchTheme();
    _applyTheme();
  }

  void changeTheme() async {
    _usingLightTheme = !_usingLightTheme;
    _saveTheme();
    _applyTheme();
  }
}
