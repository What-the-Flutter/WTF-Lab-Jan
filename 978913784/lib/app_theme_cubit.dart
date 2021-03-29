import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_theme_state.dart';
import 'data/preferences_access.dart';

class AppThemeCubit extends Cubit<AppThemeState> {
  bool _usingLightTheme = true;
  final _preferencesAccess = PreferencesAccess.instance();

  AppThemeCubit() : super(AppThemeState.darkTheme);

  void _applyTheme() async {
    final updatedState =
        _usingLightTheme ? AppThemeState.lightTheme : AppThemeState.darkTheme;
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
