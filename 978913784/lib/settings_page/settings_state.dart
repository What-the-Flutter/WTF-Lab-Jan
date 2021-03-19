class SettingsState {
  bool isDateCentered = false;
  bool isRightToLeft = false;
  int fontSizeIndex = 0;

  SettingsState(this.isDateCentered, this.isRightToLeft, this.fontSizeIndex);

  SettingsState copyWith({
    bool isDateCentered,
    bool isRightToLeft,
    int fontSizeIndex,
  }) {
    return SettingsState(
      isDateCentered ?? this.isDateCentered,
      isRightToLeft ?? this.isRightToLeft,
      fontSizeIndex ?? this.fontSizeIndex
    );
  }
}
