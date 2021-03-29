part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final bool centerDateBubble;
  final Alignment bubbleAlignment;
  final bool showCreateRecordDateTimePickerButton;
  final bool isAuthenticationOn;
  final TextTheme textTheme;

  SettingsState({
    ThemeMode themeMode,
    bool centerDateBubble,
    Alignment bubbleAlignment,
    bool showCreateRecordDateTimePicker,
    bool isAuthenticationOn,
    TextTheme textTheme,
  })  : themeMode = themeMode ?? ThemeMode.light,
        centerDateBubble = centerDateBubble ?? true,
        bubbleAlignment = bubbleAlignment ?? Alignment.centerRight,
        showCreateRecordDateTimePickerButton =
            showCreateRecordDateTimePicker ?? false,
        isAuthenticationOn = isAuthenticationOn ?? false,
        textTheme = textTheme ?? defaultTextTheme;

  SettingsState copyWith({
    ThemeMode themeMode,
    bool centerDateBubble,
    Alignment bubbleAlignment,
    bool showCreateRecordDateTimePicker,
    bool isAuthenticationOn,
    TextTheme textTheme,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      centerDateBubble: centerDateBubble ?? this.centerDateBubble,
      bubbleAlignment: bubbleAlignment ?? this.bubbleAlignment,
      showCreateRecordDateTimePicker: showCreateRecordDateTimePicker ??
          showCreateRecordDateTimePickerButton,
      isAuthenticationOn: isAuthenticationOn ?? this.isAuthenticationOn,
      textTheme: textTheme ?? this.textTheme,
    );
  }

  @override
  List<Object> get props => [
        themeMode,
        centerDateBubble,
        bubbleAlignment,
        showCreateRecordDateTimePickerButton,
        isAuthenticationOn,
        textTheme,
      ];
}
