class GeneralSettingsStates {
  final bool isDateTimeModification;
  final bool isBubbleAlignment;
  final bool isCenterDateBubble;

  const GeneralSettingsStates({
    this.isDateTimeModification = false,
    this.isBubbleAlignment = false,
    this.isCenterDateBubble = false,
  });

  GeneralSettingsStates copyWith({
    bool? isDateTimeModification,
    bool? isBubbleAlignment,
    bool? isCenterDateBubble,
  }) {
    return GeneralSettingsStates(
      isDateTimeModification:
      isDateTimeModification ?? this.isDateTimeModification,
      isBubbleAlignment: isBubbleAlignment ?? this.isBubbleAlignment,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
    );
  }
}