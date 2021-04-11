import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../data/constants/constants.dart';

part 'visual_setting_state.dart';

class VisualSettingCubit extends Cubit<VisualSettingState> {
  VisualSettingCubit({
    int index,
  }) : super(VisualSettingState()) {
    emit(index == 0 ? darkTheme : lightTheme);
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
  }
}
