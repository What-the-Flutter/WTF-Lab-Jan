class GeneralSettingsStates {
  final bool isDateTimeModification;
  final bool isBubbleAlignment;
  final bool isCenterDateBubble;
  final int textSize;

  const GeneralSettingsStates({
    this.textSize = 15,
    this.isDateTimeModification = false,
    this.isBubbleAlignment = false,
    this.isCenterDateBubble = false,
  });

  GeneralSettingsStates copyWith({
    int? textSize,
    bool? isDateTimeModification,
    bool? isBubbleAlignment,
    bool? isCenterDateBubble,
  }) {
    return GeneralSettingsStates(
      textSize: textSize ?? this.textSize,
      isDateTimeModification: isDateTimeModification ?? this.isDateTimeModification,
      isBubbleAlignment: isBubbleAlignment ?? this.isBubbleAlignment,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
    );
  }
}