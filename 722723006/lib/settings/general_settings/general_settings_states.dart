part of 'general_settings_cubit.dart';

class GeneralSettingsStates {
  bool isCenterDateBubble = false;
  bool isBubbleAlignment = false;
  bool isDateTimeModification = false;
  bool isThemeChange = false;

  GeneralSettingsStates copyWith({
    bool isCenterDateBubble,
    bool isBubbleAlignment,
    bool isDateTimeModification,
    bool isThemeChange,
  }) {
    var state = GeneralSettingsStates();
    state.isCenterDateBubble = isCenterDateBubble ?? this.isCenterDateBubble;
    state.isBubbleAlignment = isBubbleAlignment ?? this.isBubbleAlignment;
    state.isDateTimeModification =
        isDateTimeModification ?? this.isDateTimeModification;
    state.isThemeChange = isThemeChange ?? this.isThemeChange;
    return state;
  }
}
