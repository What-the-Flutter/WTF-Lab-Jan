import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../util/theme/text_themes.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences preferences;

  SettingsCubit({required this.preferences})
      : super(
          SettingsState(
            themeMode: _themeModeFromString(
              preferences.getString('themeMode'),
            ),
            bubbleAlignment: _bubbleAlignmentFromString(
              preferences.getString('bubbleAlignment'),
            ),
            textTheme: _textThemeFromString(
              preferences.getString('textTheme'),
            ),
          ),
        );
  void reset() {
    final initialState = SettingsState();
    preferences
      ..setString(
        'themeMode',
        _stringFromThemeMode(initialState.themeMode),
      )
      ..setString(
        'bubbleAlignment',
        _stringFromBubbleAlignment(initialState.bubbleAlignment),
      )
      ..setString(
        'textTheme',
        _stringFromTextTheme(initialState.textTheme),
      );
    emit(initialState);
  }

  void setTextTheme(String textThemeName) {
    preferences.setString('textTheme', textThemeName);
    emit(
      state.copyWith(
        textTheme: _textThemeFromString(textThemeName),
      ),
    );
  }

  static TextTheme _textThemeFromString(String? string) {
    switch (string) {
      case 'small':
        return smallTextTheme;
      case 'large':
        return largeTextTheme;
      default:
        return defaultTextTheme;
    }
  }

  static String _stringFromTextTheme(TextTheme textTheme) {
    if (textTheme == smallTextTheme) return 'small';
    if (textTheme == largeTextTheme) return 'large';
    return 'default';
  }

  void changeBubbleAlignment() async {
    if (state.bubbleAlignment == Alignment.centerRight) {
      preferences.setString('bubbleAlignment', 'left');
      emit(
        state.copyWith(
          bubbleAlignment: Alignment.centerLeft,
        ),
      );
    } else if (state.bubbleAlignment == Alignment.centerLeft) {
      preferences.setString('bubbleAlignment', 'right');
      emit(
        state.copyWith(
          bubbleAlignment: Alignment.centerRight,
        ),
      );
    }
  }

  void changeTheme() async {
    if (state.themeMode == ThemeMode.light) {
      preferences.setString('themeMode', 'dark');
      emit(state.copyWith(themeMode: ThemeMode.dark));
    } else if (state.themeMode == ThemeMode.dark) {
      preferences.setString('themeMode', 'light');
      emit(state.copyWith(themeMode: ThemeMode.light));
    }
  }

  static ThemeMode _themeModeFromString(String? string) {
    switch (string) {
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.light;
    }
  }

  static String _stringFromThemeMode(ThemeMode themeMode) {
    if (themeMode == ThemeMode.dark) return 'dark';
    return 'light';
  }

  static Alignment _bubbleAlignmentFromString(String? string) {
    switch (string) {
      case 'left':
        return Alignment.centerLeft;
      default:
        return Alignment.centerRight;
    }
  }

  static String _stringFromBubbleAlignment(Alignment alignment) {
    if (alignment == Alignment.centerRight) return 'right';
    if (alignment == Alignment.centerLeft) return 'left';
    return 'right';
  }
}
