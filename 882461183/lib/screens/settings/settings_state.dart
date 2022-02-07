part of 'settings_cubit.dart';

class SettingsState {
  final String themeData;
  final ThemeData theme;

  SettingsState({
    this.themeData = 'light',
    required this.theme,
  });

  SettingsState copyWith({
    String? themeData,
    ThemeData? theme,
  }) {
    return SettingsState(
      themeData: themeData ?? this.themeData,
      theme: theme ?? this.theme,
    );
  }
}
