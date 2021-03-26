import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences preferences;

  SettingsCubit({@required this.preferences})
      : super(
          SettingsState(
            themeMode: _themeModeFromString(
              preferences.getString('themeMode'),
            ),
            centerDateBubble: preferences.getBool('centerDateBubble'),
            bubbleAlignment: _bubbleAlignmentFromString(
              preferences.getString('bubbleAlignment'),
            ),
            showCreateRecordDateTimePicker:
                preferences.getBool('showCreateRecordDateTimePicker'),
            isAuthenticationOn: preferences.getBool('isAuthenticationOn'),
          ),
        );

  void switchAuthenticationOn() {
    preferences.setBool(
      'isAuthenticationOn',
      !state.isAuthenticationOn,
    );
    emit(
      state.copyWith(
        isAuthenticationOn: !state.isAuthenticationOn,
      ),
    );
  }

  void switchShowCreateRecordDateTimePicker() async {
    preferences.setBool(
      'showCreateRecordDateTimePicker',
      !state.showCreateRecordDateTimePickerButton,
    );
    emit(
      state.copyWith(
        showCreateRecordDateTimePicker:
            !state.showCreateRecordDateTimePickerButton,
      ),
    );
  }

  void switchBubbleAlignment() async {
    if (state.bubbleAlignment == Alignment.centerRight) {
      preferences?.setString('bubbleAlignment', 'left');
      emit(
        state.copyWith(
          bubbleAlignment: Alignment.centerLeft,
        ),
      );
    } else if (state.bubbleAlignment == Alignment.centerLeft) {
      preferences?.setString('bubbleAlignment', 'right');
      emit(
        state.copyWith(
          bubbleAlignment: Alignment.centerRight,
        ),
      );
    }
  }

  void switchCenterDateBubble() async {
    preferences.setBool(
      'centerDateBubble',
      !state.centerDateBubble,
    );
    emit(
      state.copyWith(
        centerDateBubble: !state.centerDateBubble,
      ),
    );
  }

  void switchThemeMode() async {
    if (state.themeMode == ThemeMode.light) {
      preferences?.setString('themeMode', 'dark');
      emit(state.copyWith(themeMode: ThemeMode.dark));
    } else if (state.themeMode == ThemeMode.dark) {
      preferences?.setString('themeMode', 'light');
      emit(state.copyWith(themeMode: ThemeMode.light));
    }
  }

  static ThemeMode _themeModeFromString(String string) {
    switch (string) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.light;
    }
  }

  static Alignment _bubbleAlignmentFromString(String string) {
    switch (string) {
      case 'right':
        return Alignment.centerRight;
      case 'left':
        return Alignment.centerLeft;
      default:
        return Alignment.centerRight;
    }
  }
}
