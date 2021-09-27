class GeneralSettingsStates {
  final bool isDateTimeModification;
  final bool isBubbleAlignment;
  final bool isCenterDateBubble;
  final int textSize;
  final String? imagePath;

  const GeneralSettingsStates({
    this.imagePath,
    this.textSize = 15,
    this.isDateTimeModification = false,
    this.isBubbleAlignment = false,
    this.isCenterDateBubble = false,
  });

  GeneralSettingsStates copyWith({
    String? imagePath,
    int? textSize,
    bool? isDateTimeModification,
    bool? isBubbleAlignment,
    bool? isCenterDateBubble,
  }) {
    return GeneralSettingsStates(
      imagePath: imagePath ?? this.imagePath,
      textSize: textSize ?? this.textSize,
      isDateTimeModification: isDateTimeModification ?? this.isDateTimeModification,
      isBubbleAlignment: isBubbleAlignment ?? this.isBubbleAlignment,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
    );
  }
}