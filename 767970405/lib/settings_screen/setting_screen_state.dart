part of 'setting_screen_cubit.dart';

enum ThemeType { light, dark }

class SettingScreenState extends Equatable {
  final double titleFontSize;
  final Color titleColor;
  final double bodyFontSize;
  final Color bodyColor;
  final Color botIconColor;
  final Color botBackgroundColor;
  final Color categoryBackgroundColor;
  final Color categoryIconColor;
  final Color messageUnselectedColor;
  final Color messageSelectedColor;
  final Color dateTimeModeButtonBackgroundColor;
  final Color dateTimeModeButtonIconColor;
  final Color labelDateBackgroundColor;
  final Color helpWindowBackgroundColor;
  final Brightness appBrightness;
  final Color appPrimaryColor;
  final Color appAccentColor;
  final String appFontFamily;
  final double appBarTitleFontSize;
  final double floatingWindowFontSize;

  final bool isDateTimeModification;
  final bool isLeftBubbleAlign;
  final bool isCenterDateBubble;
  final bool isAuthentication;

  final String pathBackgroundImage;

  SettingScreenState({
    this.titleFontSize = DefaultFontSize.titleText,
    this.titleColor,
    this.bodyFontSize = DefaultFontSize.bodyText,
    this.bodyColor,
    this.botIconColor,
    this.botBackgroundColor,
    this.categoryBackgroundColor,
    this.categoryIconColor,
    this.messageUnselectedColor,
    this.messageSelectedColor,
    this.dateTimeModeButtonBackgroundColor,
    this.dateTimeModeButtonIconColor,
    this.labelDateBackgroundColor,
    this.helpWindowBackgroundColor,
    this.appBrightness,
    this.appPrimaryColor,
    this.appAccentColor = Colors.amberAccent,
    this.appFontFamily,
    this.appBarTitleFontSize = DefaultFontSize.appBarTitle,
    this.floatingWindowFontSize = DefaultFontSize.floatingWindowText,
    this.isDateTimeModification = false,
    this.isLeftBubbleAlign = false,
    this.isCenterDateBubble = false,
    this.isAuthentication = false,
    this.pathBackgroundImage = '',
  });

  SettingScreenState copyWith({
    final double titleFontSize,
    final Color titleColor,
    final double bodyFontSize,
    final Color bodyColor,
    final Color botIconColor,
    final Color botBackgroundColor,
    final Color categoryBackgroundColor,
    final Color categoryIconColor,
    final Color messageUnselectedColor,
    final Color messageSelectedColor,
    final Color dateTimeModeButtonBackgroundColor,
    final Color dateTimeModeButtonIconColor,
    final Color labelDateBackgroundColor,
    final Color helpWindowBackgroundColor,
    final Brightness appBrightness,
    final Color appPrimaryColor,
    final Color appAccentColor,
    final String appFontFamily = 'Roboto',
    final double appBarTitleFontSize,
    final bool isDateTimeModification,
    final bool isLeftBubbleAlign,
    final bool isCenterDateBubble,
    final bool isAuthentication,
    final String pathBackgroundImage,
    final double floatingWindowFontSize,
  }) {
    return SettingScreenState(
      titleFontSize: titleFontSize ?? this.titleFontSize,
      titleColor: titleColor ?? this.titleColor,
      bodyFontSize: bodyFontSize ?? this.bodyFontSize,
      bodyColor: bodyColor ?? this.bodyColor,
      botIconColor: botIconColor ?? this.botIconColor,
      botBackgroundColor: botBackgroundColor ?? this.botBackgroundColor,
      categoryBackgroundColor:
          categoryBackgroundColor ?? this.categoryBackgroundColor,
      categoryIconColor: categoryIconColor ?? this.categoryIconColor,
      messageUnselectedColor:
          messageUnselectedColor ?? this.messageUnselectedColor,
      messageSelectedColor: messageSelectedColor ?? this.messageSelectedColor,
      dateTimeModeButtonBackgroundColor: dateTimeModeButtonBackgroundColor ??
          this.dateTimeModeButtonBackgroundColor,
      dateTimeModeButtonIconColor:
          dateTimeModeButtonIconColor ?? this.dateTimeModeButtonIconColor,
      labelDateBackgroundColor:
          labelDateBackgroundColor ?? this.labelDateBackgroundColor,
      helpWindowBackgroundColor:
          helpWindowBackgroundColor ?? this.helpWindowBackgroundColor,
      appBrightness: appBrightness ?? this.appBrightness,
      appPrimaryColor: appPrimaryColor ?? this.appPrimaryColor,
      appAccentColor: appAccentColor ?? this.appAccentColor,
      appFontFamily: appFontFamily ?? this.appFontFamily,
      appBarTitleFontSize: appBarTitleFontSize ?? this.appBarTitleFontSize,
      isDateTimeModification:
          isDateTimeModification ?? this.isDateTimeModification,
      isLeftBubbleAlign: isLeftBubbleAlign ?? this.isLeftBubbleAlign,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
      isAuthentication: isAuthentication ?? this.isAuthentication,
      pathBackgroundImage: pathBackgroundImage ?? this.pathBackgroundImage,
      floatingWindowFontSize:
          floatingWindowFontSize ?? this.floatingWindowFontSize,
    );
  }

  @override
  List<Object> get props => [
        titleFontSize,
        titleColor,
        bodyFontSize,
        bodyColor,
        botIconColor,
        botBackgroundColor,
        categoryBackgroundColor,
        categoryIconColor,
        messageUnselectedColor,
        messageSelectedColor,
        dateTimeModeButtonBackgroundColor,
        dateTimeModeButtonIconColor,
        labelDateBackgroundColor,
        helpWindowBackgroundColor,
        appBrightness,
        appAccentColor,
        appFontFamily,
        isDateTimeModification,
        isLeftBubbleAlign,
        isCenterDateBubble,
        isAuthentication,
        pathBackgroundImage,
        floatingWindowFontSize,
      ];
}
