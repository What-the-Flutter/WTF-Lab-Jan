import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import '../../database/preferences.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.initial());

  void changeThemeColor() {
    final newThemeColor = ThemeColor.values[(state.tColor.index + 1) % 2];
    emit(state.duplicate(tColor: newThemeColor));
    _saveToPreferences('theme', state.tColor.index);
  }

  void changeFontSize(FontSize newFontSize) {
    emit(state.duplicate(fSize: newFontSize));
    _saveToPreferences('font_size', state.fSize.index);
  }

  void changeBubbleAlignment(MainAxisAlignment alignment) {
    emit(state.duplicate(bubbleAlignment: alignment));
    _saveToPreferences('bubble_align', state.bubbleAlignment.index);
  }

  void changeBackground(ChatBackground background) {
    emit(state.duplicate(chBackground: background));
    _saveToPreferences('chat_back', state.chBackground.index);
  }

  void resetSettings() {
    emit(state.duplicate(
      tColor: ThemeColor.light,
      fSize: FontSize.medium,
      bubbleAlignment: MainAxisAlignment.start,
      chBackground: ChatBackground.empty,
    ));
    _saveToPreferences('theme', ThemeColor.light.index);
    _saveToPreferences('font_size', FontSize.medium.index);
    _saveToPreferences('bubble_align', MainAxisAlignment.start.index);
    _saveToPreferences('chat_back', ChatBackground.empty.index);
  }

  void _saveToPreferences(String key, int value) async {
    await Preferences.data!.setInt(key, value);
  }
}
