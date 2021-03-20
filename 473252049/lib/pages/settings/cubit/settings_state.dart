part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final bool centerDateBubble;
  final Alignment bubbleAlignment;

  SettingsState(
      {this.themeMode = ThemeMode.light,
      bool centerDateBubble,
      Alignment bubbleAlignment})
      : centerDateBubble = centerDateBubble ?? true,
        bubbleAlignment = bubbleAlignment ?? Alignment.centerRight;

  SettingsState copyWith(
      {ThemeMode themeMode, bool centerDateBubble, Alignment bubbleAlignment}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      centerDateBubble: centerDateBubble ?? this.centerDateBubble,
      bubbleAlignment: bubbleAlignment ?? this.bubbleAlignment,
    );
  }

  @override
  List<Object> get props => [
        themeMode,
        centerDateBubble,
        bubbleAlignment,
      ];
}
