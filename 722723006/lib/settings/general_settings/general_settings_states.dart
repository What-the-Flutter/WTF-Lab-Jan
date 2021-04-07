part of 'general_settings_cubit.dart';

class GeneralSettingsStates {
  final bool isCenterDateBubble;
  final bool isBubbleAlignment;
  final bool isDateTimeModification;

  GeneralSettingsStates copyWith({
    final bool isCenterDateBubble,
    final bool isBubbleAlignment,
    final bool isDateTimeModification,
  }) {
    return GeneralSettingsStates(
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
      isBubbleAlignment: isBubbleAlignment ?? this.isBubbleAlignment,
      isDateTimeModification:
          isDateTimeModification ?? this.isDateTimeModification,
    );
  }

  const GeneralSettingsStates({
    this.isCenterDateBubble,
    this.isBubbleAlignment,
    this.isDateTimeModification,
  });
}
