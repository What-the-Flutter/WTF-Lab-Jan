class StatesGeneralSettings {
  bool isDateTimeModification;
  bool isBubbleAlignment;
  bool isCenterDateBubble;

  StatesGeneralSettings copyWith({
    bool isDateTimeModification,
    bool isBubbleAlignment,
    bool isCenterDateBubble,
  }) {
    var state = StatesGeneralSettings();
    state.isDateTimeModification =
        isDateTimeModification ?? this.isDateTimeModification;
    state.isBubbleAlignment = isBubbleAlignment ?? this.isBubbleAlignment;
    state.isCenterDateBubble = isCenterDateBubble ?? this.isCenterDateBubble;
    return state;
  }
}
