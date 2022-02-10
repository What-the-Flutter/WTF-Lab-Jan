part of 'settings_cubit.dart';

class SettingsState {
  final Themes themeData;
  final ThemeData theme;
  final double fontSize;
  final String fontSizeString;
  final bool isBubbleChatleft;
  final String backgroundImagePath;

  SettingsState({
    this.themeData = Themes.light,
    required this.theme,
    this.fontSize = 16,
    this.fontSizeString = 'Medium',
    this.isBubbleChatleft = true,
    this.backgroundImagePath = '',
  });

  SettingsState copyWith({
    Themes? themeData,
    ThemeData? theme,
    double? fontSize,
    String? fontSizeString,
    bool? isBubbleChatleft,
    String? backgroundImagePath,
  }) {
    return SettingsState(
      themeData: themeData ?? this.themeData,
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
      fontSizeString: fontSizeString ?? this.fontSizeString,
      isBubbleChatleft: isBubbleChatleft ?? this.isBubbleChatleft,
      backgroundImagePath: backgroundImagePath ?? this.backgroundImagePath,
    );
  }
}
