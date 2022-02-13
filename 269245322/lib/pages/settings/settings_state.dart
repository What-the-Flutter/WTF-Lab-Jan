class SettingsState {
  final int textSize;
  final int aligment;
  final int theme;
  final int database;

  SettingsState({
    required this.textSize,
    required this.aligment,
    required this.theme,
    required this.database,
  });

  SettingsState copyWith({
    final int? textSize,
    final int? aligment,
    final int? theme,
    final int? database,
  }) {
    return SettingsState(
      textSize: textSize ?? this.textSize,
      aligment: aligment ?? this.aligment,
      theme: theme ?? this.theme,
      database: database ?? this.database,
    );
  }
}
