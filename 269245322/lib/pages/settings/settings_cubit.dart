import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared_preferences/sp_settings_helper.dart';
import '../../style/app_themes.dart';
import '../../style/theme_cubit.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(
          SettingsState(
            textSize: 0,
            aligment: 0,
            theme: 0,
            database: 0,
          ),
        );

  final SharedPreferencesProvider _sharedPreferencesProvider =
      SharedPreferencesProvider();

  void initState() {
    final initTextSize = _sharedPreferencesProvider.getTextSize();
    final initAligment = _sharedPreferencesProvider.getALigment();
    final initTheme = _sharedPreferencesProvider.getTheme();
    final initDatabase = _sharedPreferencesProvider.getDatabase();

    emit(
      state.copyWith(
        textSize: initTextSize,
        aligment: initAligment,
        theme: initTheme,
        database: initDatabase,
      ),
    );
  }

  void changeTextSize(int appTextSize) {
    final newTextSize = appTextSize;

    _sharedPreferencesProvider.changeTextSize(newTextSize);
    emit(state.copyWith(textSize: newTextSize));
  }

  void changeAligment(int appAligment) {
    final newAligment = appAligment;

    _sharedPreferencesProvider.changeALigment(newAligment);
    emit(state.copyWith(aligment: newAligment));
  }

  void changeTheme(int appTheme, ThemeCubit themeCubit) {
    final newTheme = appTheme;

    _sharedPreferencesProvider.changeTheme(newTheme);
    emit(state.copyWith(theme: newTheme));
    appTheme == 0
        ? themeCubit.changeTheme(appThemeData[AppTheme.blueLight]!)
        : themeCubit.changeTheme(appThemeData[AppTheme.blueDark]!);
  }

  void changeDatabase(int appDatabase) {
    final newDatabase = appDatabase;

    _sharedPreferencesProvider.changeDatabase(newDatabase);
    emit(state.copyWith(database: newDatabase));
  }

  void resetSettings(ThemeCubit themeCubit) {
    _sharedPreferencesProvider.resetSettings();
    changeTheme(0, themeCubit);
  }
}
