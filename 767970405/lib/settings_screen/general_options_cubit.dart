import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/constans/constans.dart';

part 'general_options_state.dart';

class GeneralOptionsCubit extends Cubit<GeneralOptionsState> {
  GeneralOptionsCubit({
    int index,
  }) : super(GeneralOptionsState()) {
    emit(index == 0 ? darkTheme : lightTheme);
  }

  GeneralOptionsState get lightTheme => GeneralOptionsState(
        titleColor: Colors.black,
        bodyColor: Colors.black.withOpacity(0.4),
        botIconColor: Colors.black,
        botBackgroundColor: Colors.green[50],
        categoryBackgroundColor: Colors.teal[200],
        categoryIconColor: Colors.white,
        messageUnselectedColor: Colors.green[50],
        messageSelectedColor: Colors.green[200],
        dateTimeModeButtonBackgroundColor: Colors.red[50],
        dateTimeModeButtonIconColor: Colors.white,
        labelDateBackgroundColor: Colors.red,
        helpWindowBackgroundColor: Colors.green[50],
        appBrightness: Brightness.light,
        appPrimaryColor: Colors.teal,
      );

  GeneralOptionsState get darkTheme => GeneralOptionsState(
        titleColor: Colors.white,
        bodyColor: Colors.white,
        botIconColor: Colors.white,
        botBackgroundColor: Colors.black,
        categoryBackgroundColor: Colors.teal[200],
        categoryIconColor: Colors.white,
        messageUnselectedColor: Colors.black,
        messageSelectedColor: Colors.orangeAccent,
        dateTimeModeButtonBackgroundColor: Colors.red[50],
        dateTimeModeButtonIconColor: Colors.white,
        labelDateBackgroundColor: Colors.red,
        helpWindowBackgroundColor: Colors.black,
        appBrightness: Brightness.dark,
        appPrimaryColor: Colors.black,
      );

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
        emit(state.copyWith(
          titleFontSize: DefaultFontSize.titleText * kSmall,
          bodyFontSize: DefaultFontSize.bodyText * kSmall,
          appBarTitleFontSize: DefaultFontSize.appBarTitle * kSmall,
        ));
        break;
      case TypeFontSize.def:
        emit(state.copyWith(
          titleFontSize: DefaultFontSize.titleText,
          bodyFontSize: DefaultFontSize.bodyText,
          appBarTitleFontSize: DefaultFontSize.appBarTitle,
        ));
        break;
      case TypeFontSize.large:
        emit(state.copyWith(
          titleFontSize: DefaultFontSize.titleText * kLarge,
          bodyFontSize: DefaultFontSize.bodyText * kLarge,
          appBarTitleFontSize: DefaultFontSize.appBarTitle * kLarge,
        ));
        break;
    }
  }

  void resetSettings() {
    emit(lightTheme);
  }

  void changeBubbleAlign(bool value) {
    emit(state.copyWith(isLeftBubbleAlign: value));
  }

  void changeDateTimeModification(bool value) {
    emit(state.copyWith(isDateTimeModification: value));
  }

  void changeCenterDateBubble(bool value) {
    emit(state.copyWith(isCenterDateBubble: value));
  }

  void changeAuthentication(bool value) {
    emit(state.copyWith(isAuthentication: value));
  }

  void pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    emit(state.copyWith(pathBackgroundImage: pickedFile.path));
  }

  void unsetImage() {
    emit(state.copyWith(pathBackgroundImage: ''));
  }
}
