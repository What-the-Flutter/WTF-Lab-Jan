import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/constants/constants.dart';

part 'visual_setting_state.dart';

class VisualSettingCubit extends Cubit<VisualSettingState> {
  VisualSettingCubit() : super(VisualSettingState()) {
    loadAllSettings();
  }

  VisualSettingState get lightTheme {
    return state.copyWith(
      titleColor: Colors.black,
      bodyColor: Colors.black.withOpacity(0.4),
      botIconColor: Colors.black,
      botBackgroundColor: Colors.orange,
      categoryBackgroundColor: Colors.teal[200],
      categoryIconColor: Colors.white,
      iconColor: Colors.black,
      messageUnselectedColor: Colors.green[50],
      messageSelectedColor: Colors.green[200],
      dateTimeModeButtonBackgroundColor: Colors.red[50],
      dateTimeModeButtonIconColor: Colors.white,
      labelDateBackgroundColor: Colors.red,
      helpWindowBackgroundColor: Colors.green[50],
      appBrightness: Brightness.light,
      appPrimaryColor: Colors.teal,
      textFieldColor: Colors.black,
      disabledTextFieldColor: Colors.grey,
    );
  }

  VisualSettingState get darkTheme {
    return state.copyWith(
      titleColor: Colors.white,
      bodyColor: Colors.white,
      botIconColor: Colors.white,
      botBackgroundColor: Colors.orange,
      categoryBackgroundColor: Colors.teal[200],
      categoryIconColor: Colors.white,
      iconColor: Colors.white,
      messageUnselectedColor: Colors.black,
      messageSelectedColor: Colors.orangeAccent,
      dateTimeModeButtonBackgroundColor: Colors.red[50],
      dateTimeModeButtonIconColor: Colors.white,
      labelDateBackgroundColor: Colors.red,
      helpWindowBackgroundColor: Colors.black,
      appBrightness: Brightness.dark,
      appPrimaryColor: Colors.black,
      textFieldColor: Colors.white,
      disabledTextFieldColor: Colors.grey,
    );
  }

  void toggleTheme() {
    if (state.appBrightness == Brightness.dark) {
      emit(lightTheme);
    } else if (state.appBrightness == Brightness.light) {
      emit(darkTheme);
    }
  }

  void changeFontSize(TypeFontSize typeFontSize) {
    switch (typeFontSize) {
      case TypeFontSize.small:
        emit(
          state.copyWith(
            titleFontSize: DefaultFontSize.titleText * kSmall,
            bodyFontSize: DefaultFontSize.bodyText * kSmall,
            appBarTitleFontSize: DefaultFontSize.appBarTitle * kSmall,
            floatingWindowFontSize: DefaultFontSize.floatingWindowText * kSmall,
          ),
        );
        break;
      case TypeFontSize.def:
        emit(
          state.copyWith(
            titleFontSize: DefaultFontSize.titleText,
            bodyFontSize: DefaultFontSize.bodyText,
            appBarTitleFontSize: DefaultFontSize.appBarTitle,
            floatingWindowFontSize: DefaultFontSize.floatingWindowText,
          ),
        );
        break;
      case TypeFontSize.large:
        emit(
          state.copyWith(
            titleFontSize: DefaultFontSize.titleText * kLarge,
            bodyFontSize: DefaultFontSize.bodyText * kLarge,
            appBarTitleFontSize: DefaultFontSize.appBarTitle * kLarge,
            floatingWindowFontSize: DefaultFontSize.floatingWindowText * kLarge,
          ),
        );
        break;
    }
  }

  void changeFontFamily(TypeFontFamily typeFontFamily) {
    switch (typeFontFamily) {
      case TypeFontFamily.roboto:
        emit(state.copyWith(appFontFamily: 'Roboto'));
        break;
      case TypeFontFamily.robotoMono:
        emit(state.copyWith(appFontFamily: 'RobotoMono'));
        break;
    }
  }

  void loadAllSettings() async {
    var indexTheme = await loadVisualSettings('theme');
    var indexAccentColor = await loadVisualSettings('accentColor');
    var indexTypeFace = await loadVisualSettings('typeFace');
    var indexFontSize = await loadVisualSettings('fontSize');
    emit(indexTheme == 0 ? darkTheme : lightTheme);
    changeAccentColor(TypeAccentColor.values[indexAccentColor]);
    changeFontFamily(TypeFontFamily.values[indexTypeFace]);
    changeFontSize(TypeFontSize.values[indexFontSize]);
  }

  void changeAccentColor(TypeAccentColor typeAccentColor) {
    switch (typeAccentColor) {
      case TypeAccentColor.gold:
        emit(state.copyWith(appAccentColor: Colors.amberAccent));
        break;
      case TypeAccentColor.cyan:
        emit(state.copyWith(appAccentColor: Colors.cyan));
        break;
      case TypeAccentColor.mint:
        emit(state.copyWith(appAccentColor: Colors.greenAccent));
        break;
      case TypeAccentColor.lime:
        emit(state.copyWith(appAccentColor: Colors.lime));
        break;
      case TypeAccentColor.pink:
        emit(state.copyWith(appAccentColor: Colors.pink));
        break;
      case TypeAccentColor.green:
        emit(state.copyWith(appAccentColor: Colors.green));
        break;
      case TypeAccentColor.orange:
        emit(state.copyWith(appAccentColor: Colors.orange));
        break;
    }
  }

  void resetVisualSetting() {
    emit(
      lightTheme.copyWith(
        titleFontSize: DefaultFontSize.titleText,
        bodyFontSize: DefaultFontSize.bodyText,
        appBarTitleFontSize: DefaultFontSize.appBarTitle,
        floatingWindowFontSize: DefaultFontSize.floatingWindowText,
        appAccentColor: Colors.amberAccent,
        appFontFamily: 'Roboto',
      ),
    );
    saveVisualSettings('fontSize', 0);
    saveVisualSettings('accentColor', 0);
    saveVisualSettings('typeFace', 0);
    saveVisualSettings('theme', 1);
  }

  Future<int> loadVisualSettings(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  Future<void> saveVisualSettings(String key, int index) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, index);
  }
}
