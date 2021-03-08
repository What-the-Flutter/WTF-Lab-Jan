class SettingsScreenState {
  final bool isLeftBubbleAlignment;
  final bool isDateTimeModification;

  const SettingsScreenState(
    this.isLeftBubbleAlignment,
    this.isDateTimeModification,
  );

  SettingsScreenState copyWith({
    final bool isLeftBubbleAlignment,
    final bool isDateTimeModification,
  }) {
    return SettingsScreenState(
      isLeftBubbleAlignment ?? this.isLeftBubbleAlignment,
      isDateTimeModification ?? this.isDateTimeModification,
    );
  }
}
