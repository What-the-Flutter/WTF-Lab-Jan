import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared_preferences/sp_settings_helper.dart';
import '../../style/custom_theme.dart';
import '../../style/themes.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(SettingsState(
          textSize: 0,
          aligment: 0,
          theme: 0,
        ));

  final SharedPreferencesProvider _sharedPreferencesProvider =
      SharedPreferencesProvider();
  void initState() {
    final initTextSize = _sharedPreferencesProvider.getTextSize();
    final initAligment = _sharedPreferencesProvider.getALigment();
    final initTheme = _sharedPreferencesProvider.getTheme();

    emit(state.copyWith(
        textSize: initTextSize, aligment: initAligment, theme: initTheme));
  }

  void changeTextSize(int appTextSize) {
    final newTextSize = appTextSize;

    SharedPreferencesProvider.changeTextSize(newTextSize);
    emit(state.copyWith(textSize: newTextSize));
  }

  void changeAligment(int appAligment) {
    final newAligment = appAligment;

    SharedPreferencesProvider.changeALigment(newAligment);
    emit(state.copyWith(aligment: newAligment));
  }

  void changeTheme(int appTheme, BuildContext buildContext) {
    final newTheme = appTheme;

    SharedPreferencesProvider.changeTheme(newTheme);
    emit(state.copyWith(theme: newTheme));
    appTheme == 0
        ? CustomTheme.instanceOf(buildContext).changeTheme(MyThemeKeys.light)
        : CustomTheme.instanceOf(buildContext).changeTheme(MyThemeKeys.dark);
  }

  void resetSettings(BuildContext context) {
    SharedPreferencesProvider.resetSettings();
    changeTheme(0, context);
    Navigator.pop(context);
  }
}
