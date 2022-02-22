part of 'settings_cubit.dart';

class SettingsState {
  final int themeData;
  final ThemeData theme;
  final double fontSize;
  final String fontSizeString;
  final bool isBubbleChatleft;
  final bool isDateCenterAlign;
  final String backgroundImagePath;

  SettingsState({
    this.themeData = 0,
    required this.theme,
    this.fontSize = 16,
    this.fontSizeString = 'Medium',
    this.isBubbleChatleft = true,
    this.isDateCenterAlign = false,
    this.backgroundImagePath = '',
  });

  SettingsState copyWith({
    int? themeData,
    ThemeData? theme,
    double? fontSize,
    String? fontSizeString,
    bool? isBubbleChatleft,
    bool? isDateCenterAlign,
    String? backgroundImagePath,
  }) {
    return SettingsState(
      themeData: themeData ?? this.themeData,
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
      fontSizeString: fontSizeString ?? this.fontSizeString,
      isBubbleChatleft: isBubbleChatleft ?? this.isBubbleChatleft,
      isDateCenterAlign: isDateCenterAlign ?? this.isDateCenterAlign,
      backgroundImagePath: backgroundImagePath ?? this.backgroundImagePath,
    );
  }
}
