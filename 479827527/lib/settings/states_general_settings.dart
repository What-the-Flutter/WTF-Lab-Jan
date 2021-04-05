class StatesGeneralSettings {
  final bool isDateTimeModification;
  final bool isBubbleAlignment;
  final bool isCenterDateBubble;

  const StatesGeneralSettings({
    this.isDateTimeModification,
    this.isBubbleAlignment,
    this.isCenterDateBubble,
  });

  StatesGeneralSettings copyWith({
    final bool isDateTimeModification,
    final bool isBubbleAlignment,
    final bool isCenterDateBubble,
  }) {
    return StatesGeneralSettings(
      isDateTimeModification:
          isDateTimeModification ?? this.isDateTimeModification,
      isBubbleAlignment: isBubbleAlignment ?? this.isBubbleAlignment,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
    );
  }
}
