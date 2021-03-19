part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;

  SettingsState({this.themeMode});

  SettingsState copyWith({ThemeMode themeMode}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object> get props => [themeMode];
}
