part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Alignment bubbleAlignment;
  final TextTheme textTheme;

  SettingsState({
    ThemeMode? themeMode,
    Alignment? bubbleAlignment,
    TextTheme? textTheme,
  })  : themeMode = themeMode ?? ThemeMode.light,
        bubbleAlignment = bubbleAlignment ?? Alignment.centerRight,
        textTheme = textTheme ?? defaultTextTheme;

  SettingsState copyWith({
    ThemeMode? themeMode,
    Alignment? bubbleAlignment,
    TextTheme? textTheme,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      bubbleAlignment: bubbleAlignment ?? this.bubbleAlignment,
      textTheme: textTheme ?? this.textTheme,
    );
  }

  @override
  List<Object?> get props => [themeMode, bubbleAlignment, textTheme];
}
