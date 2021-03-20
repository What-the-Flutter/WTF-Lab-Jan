part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final bool centerDateBubble;
  final Alignment bubbleAlignment;
  final bool showCreateRecordDateTimePicker;

  SettingsState({
    ThemeMode themeMode,
    bool centerDateBubble,
    Alignment bubbleAlignment,
    bool showCreateRecordDateTimePicker,
  })  : themeMode = themeMode ?? ThemeMode.light,
        centerDateBubble = centerDateBubble ?? true,
        bubbleAlignment = bubbleAlignment ?? Alignment.centerRight,
        showCreateRecordDateTimePicker =
            showCreateRecordDateTimePicker ?? false;

  SettingsState copyWith({
    ThemeMode themeMode,
    bool centerDateBubble,
    Alignment bubbleAlignment,
    bool showCreateRecordDateTimePicker,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      centerDateBubble: centerDateBubble ?? this.centerDateBubble,
      bubbleAlignment: bubbleAlignment ?? this.bubbleAlignment,
      showCreateRecordDateTimePicker:
          showCreateRecordDateTimePicker ?? this.showCreateRecordDateTimePicker,
    );
  }

  @override
  List<Object> get props => [
        themeMode,
        centerDateBubble,
        bubbleAlignment,
        showCreateRecordDateTimePicker,
      ];
}
