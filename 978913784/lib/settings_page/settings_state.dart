class SettingsState {
  bool isDateCentered = false;
  bool isRightToLeft = false;

  SettingsState(this.isDateCentered, this.isRightToLeft);

  SettingsState copyWith({
    bool isDateCentered,
    bool isRightToLeft,
  }) {
    return SettingsState(
      isDateCentered ?? this.isDateCentered,
      isRightToLeft ?? this.isRightToLeft,
    );
  }
}
