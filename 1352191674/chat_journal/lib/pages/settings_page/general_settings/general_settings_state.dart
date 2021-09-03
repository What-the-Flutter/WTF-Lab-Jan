part of 'general_settings_cubit.dart';

class GeneralSettingsState {
  final bool? isCenterDateBubble;
  final bool? isBubbleAlignment;
  final bool? isDateTimeModification;

  GeneralSettingsState copyWith({
    bool? isCenterDateBubble,
    bool? isBubbleAlignment,
    bool? isDateTimeModification,
  }) {
    return GeneralSettingsState(
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
      isBubbleAlignment: isBubbleAlignment ?? this.isBubbleAlignment,
      isDateTimeModification:
          isDateTimeModification ?? this.isDateTimeModification,
    );
  }

  const GeneralSettingsState({
    this.isCenterDateBubble,
    this.isBubbleAlignment,
    this.isDateTimeModification,
  });
}
