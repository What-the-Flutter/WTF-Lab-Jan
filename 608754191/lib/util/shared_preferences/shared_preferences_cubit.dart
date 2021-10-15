import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'shared_preferences_state.dart';

class SharedPreferencesCubit extends Cubit<SharedPreferencesState> {
  final SharedPreferences preferences;

  SharedPreferencesCubit(ThemeMode themeMode, bool bubbleAlignment, {required this.preferences})
      : super(
          SharedPreferencesState(
            themeMode: themeMode,
            bubbleAlignment: bubbleAlignment,
          ),
        );

  void changeTheme() async {
    if (state.themeMode == ThemeMode.light) {
      preferences.setString(
        'themeMode',
        'dark',
      );
      emit(
        SharedPreferencesState(
          themeMode: ThemeMode.dark,
          bubbleAlignment: state.bubbleAlignment,
        ),
      );
    } else if (state.themeMode == ThemeMode.dark) {
      preferences.setString(
        'themeMode',
        'light',
      );
      emit(
        SharedPreferencesState(
          themeMode: ThemeMode.light,
          bubbleAlignment: state.bubbleAlignment,
        ),
      );
    }
  }

  void changeBubbleAlignmentWithParams(bool isBubbleAlignment) =>
      preferences.setBool('isBubbleAlignment', isBubbleAlignment);

  bool fetchBubbleAlignment() => preferences.getBool('isBubbleAlignment') ?? false;
  void updateState() {
    emit(
      SharedPreferencesState(
        themeMode: state.themeMode,
        bubbleAlignment: fetchBubbleAlignment(),
      ),
    );
  }

  void resetPreferences() {
    changeBubbleAlignmentWithParams(false);
    updateState();
  }

  void changeBubbleAlignment() {
    changeBubbleAlignmentWithParams(!state.bubbleAlignment);
    emit(
      SharedPreferencesState(
        bubbleAlignment: !state.bubbleAlignment,
        themeMode: state.themeMode,
      ),
    );
  }
}
