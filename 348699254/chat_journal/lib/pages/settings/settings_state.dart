class SettingsState {
  final bool isCategoryListOpen;

  SettingsState({
    required this.isCategoryListOpen,
  });

  SettingsState copyWith({
    bool? isCategoryListOpen,
  }) {
    return SettingsState(
      isCategoryListOpen: isCategoryListOpen ?? this.isCategoryListOpen,
    );
  }
}