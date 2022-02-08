class SettingsState {
  final int textSize;
  final int aligment;
  final int theme;

  SettingsState({
    required this.textSize,
    required this.aligment,
    required this.theme,
  });

  SettingsState copyWith({
    final int? textSize,
    final int? aligment,
    final int? theme,
  }) {
    return SettingsState(
      textSize: textSize ?? this.textSize,
      aligment: aligment ?? this.aligment,
      theme: theme ?? this.theme,
    );
  }
}
