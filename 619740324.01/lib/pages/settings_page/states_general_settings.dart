class StatesGeneralSettings {
  final bool isDateTimeModification;
  final bool isBubbleAlignment;
  final bool isCenterDateBubble;

  StatesGeneralSettings({
    this.isDateTimeModification = false,
    this.isBubbleAlignment = false,
    this.isCenterDateBubble = false,
  });

  StatesGeneralSettings copyWith({
    final bool? isDateTimeModification,
    final bool? isBubbleAlignment,
    final bool? isCenterDateBubble,
  }) {
    return StatesGeneralSettings(
      isDateTimeModification:
          isDateTimeModification ?? this.isDateTimeModification,
      isBubbleAlignment: isBubbleAlignment ?? this.isBubbleAlignment,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
    );
  }
}
