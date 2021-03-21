part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final bool centerDateBubble;
  final Alignment bubbleAlignment;
  final bool showCreateRecordDateTimePickerButton;
  final bool isAuthenticationOn;

  SettingsState({
    ThemeMode themeMode,
    bool centerDateBubble,
    Alignment bubbleAlignment,
    bool showCreateRecordDateTimePicker,
    bool isAuthenticationOn,
  })  : themeMode = themeMode ?? ThemeMode.light,
        centerDateBubble = centerDateBubble ?? true,
        bubbleAlignment = bubbleAlignment ?? Alignment.centerRight,
        showCreateRecordDateTimePickerButton =
            showCreateRecordDateTimePicker ?? false,
        isAuthenticationOn = isAuthenticationOn ?? true;

  SettingsState copyWith(
      {ThemeMode themeMode,
      bool centerDateBubble,
      Alignment bubbleAlignment,
      bool showCreateRecordDateTimePicker,
      bool isAuthenticationOn}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      centerDateBubble: centerDateBubble ?? this.centerDateBubble,
      bubbleAlignment: bubbleAlignment ?? this.bubbleAlignment,
      showCreateRecordDateTimePicker: showCreateRecordDateTimePicker ??
          this.showCreateRecordDateTimePickerButton,
      isAuthenticationOn: isAuthenticationOn ?? this.isAuthenticationOn,
    );
  }

  @override
  List<Object> get props => [
        themeMode,
        centerDateBubble,
        bubbleAlignment,
        showCreateRecordDateTimePickerButton,
        isAuthenticationOn,
      ];
}
