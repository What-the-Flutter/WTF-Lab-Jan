class SettingsScreenState {
  final bool isLeftBubbleAlignment;
  final bool isDateTimeModification;
  final int fontSize;

  const SettingsScreenState(
    this.isLeftBubbleAlignment,
    this.isDateTimeModification,
    this.fontSize,
  );

  SettingsScreenState copyWith({
    final bool isLeftBubbleAlignment,
    final bool isDateTimeModification,
    final int fontSize,
  }) {
    return SettingsScreenState(
      isLeftBubbleAlignment ?? this.isLeftBubbleAlignment,
      isDateTimeModification ?? this.isDateTimeModification,
      fontSize ?? this.fontSize,
    );
  }
}
