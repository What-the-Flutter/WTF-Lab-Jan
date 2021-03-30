part of 'general_options_cubit.dart';

enum ThemeType { light, dark }

class GeneralOptionsState extends Equatable {
  final ThemeType themeType;
  final CustomTheme currentTheme;
  final bool isDateTimeModification;
  final bool isLeftBubbleAlign;
  final bool isCenterDateBubble;
  final bool isAuthentication;

  GeneralOptionsState({
    this.themeType,
    this.currentTheme,
    this.isDateTimeModification,
    this.isLeftBubbleAlign,
    this.isCenterDateBubble,
    this.isAuthentication,
  });

  GeneralOptionsState copyWith({
    final ThemeType themeType,
    final CustomTheme currentTheme,
    final bool isDateTimeModification,
    final bool isLeftBubbleAlign,
    final bool isCenterDateBubble,
    final bool isAuthentication,
  }) {
    return GeneralOptionsState(
      themeType: themeType ?? this.themeType,
      currentTheme: currentTheme ?? this.currentTheme,
      isDateTimeModification:
          isDateTimeModification ?? this.isDateTimeModification,
      isLeftBubbleAlign: isLeftBubbleAlign ?? this.isLeftBubbleAlign,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
      isAuthentication: isAuthentication ?? this.isAuthentication,
    );
  }

  @override
  String toString() {
    return 'GeneralOptionsState{themeType: $themeType,'
        ' currentTheme: $currentTheme,'
        ' isDateTimeModification: $isDateTimeModification,'
        ' isLeftBubbleAlign: $isLeftBubbleAlign,'
        ' isCenterDateBubble: $isCenterDateBubble}';
  }

  @override
  List<Object> get props => [
        themeType,
        currentTheme,
        isDateTimeModification,
        isLeftBubbleAlign,
        isCenterDateBubble,
        isAuthentication,
      ];
}
