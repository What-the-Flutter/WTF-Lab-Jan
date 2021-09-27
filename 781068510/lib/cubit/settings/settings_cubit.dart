import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../database/shared_preferences_helper.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<GeneralSettingsStates> {
  SettingsCubit() : super(GeneralSettingsStates());

  void init() {
    emit(
      state.copyWith(
        textSize: SharedPreferencesProvider().getTextSize(),
        isDateTimeModification: SharedPreferencesProvider().getDateTimeMode(),
        isBubbleAlignment: SharedPreferencesProvider().getBubbleAlignment(),
        isCenterDateBubble: SharedPreferencesProvider().getCenterDateBubble(),
        imagePath: SharedPreferencesProvider().getImage(),
      ),
    );
  }

  void resetAllPreferences() {
    SharedPreferencesProvider().changeDateTimeMode(false);
    SharedPreferencesProvider().changeBubbleAlignment(false);
    SharedPreferencesProvider().changeCenterDateBubble(false);
    SharedPreferencesProvider().changeTextSize(15);
    init();
  }

  void changeDateTimeModification() {
    SharedPreferencesProvider()
        .changeDateTimeMode(!state.isDateTimeModification);
    emit(
      state.copyWith(isDateTimeModification: !state.isDateTimeModification),
    );
    print(state.isDateTimeModification);
  }

  void changeBubbleAlignment() {
    SharedPreferencesProvider().changeBubbleAlignment(!state.isBubbleAlignment);
    emit(
      state.copyWith(isBubbleAlignment: !state.isBubbleAlignment),
    );
  }

  void addImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      changeImagePath(imageTemporary.path);
      emit(state.copyWith(imagePath: imageTemporary.path));
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void changeImagePath(String path) {
    SharedPreferencesProvider().changeImage(path);
    emit(
      state.copyWith(imagePath: path),
    );
  }

  void changeTextSize(int size) {
    SharedPreferencesProvider().changeTextSize(size);
    emit(
      state.copyWith(textSize: size),
    );
  }

  void changeCenterDateBubble() {
    SharedPreferencesProvider()
        .changeCenterDateBubble(!state.isCenterDateBubble);
    emit(
      state.copyWith(isCenterDateBubble: !state.isCenterDateBubble),
    );
  }
}
