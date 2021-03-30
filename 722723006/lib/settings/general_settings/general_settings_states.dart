part of 'general_settings_cubit.dart';

class GeneralSettingsStates {
  bool isCenterDateBubble;
  bool isBubbleAlignment;
  bool isDateTimeModification;

  GeneralSettingsStates copyWith({
    bool isCenterDateBubble,
    bool isBubbleAlignment,
    bool isDateTimeModification,
  }) {
    var state = GeneralSettingsStates();
    state.isCenterDateBubble = isCenterDateBubble ?? this.isCenterDateBubble;
    state.isBubbleAlignment = isBubbleAlignment ?? this.isBubbleAlignment;
    state.isDateTimeModification =
        isDateTimeModification ?? this.isDateTimeModification;
    return state;
  }
}
