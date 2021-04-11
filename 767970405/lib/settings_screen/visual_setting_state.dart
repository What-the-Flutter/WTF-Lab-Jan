part of 'visual_setting_cubit.dart';

class VisualSettingState extends Equatable {
  final double titleFontSize;
  final Color titleColor;
  final double bodyFontSize;
  final Color bodyColor;
  final Color botIconColor;
  final Color botBackgroundColor;
  final Color categoryBackgroundColor;
  final Color categoryIconColor;
  final Color iconColor;
  final Color messageUnselectedColor;
  final Color messageSelectedColor;
  final Color dateTimeModeButtonBackgroundColor;
  final Color dateTimeModeButtonIconColor;
  final Color labelDateBackgroundColor;
  final Color helpWindowBackgroundColor;
  final Brightness appBrightness;
  final Color appPrimaryColor;
  final Color appAccentColor;
  final Color textFieldColor;
  final Color disabledTextFieldColor;
  final String appFontFamily;
  final double appBarTitleFontSize;
  final double floatingWindowFontSize;

  VisualSettingState({
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
    this.iconColor,
    this.dateTimeModeButtonBackgroundColor,
    this.dateTimeModeButtonIconColor,
    this.labelDateBackgroundColor,
    this.helpWindowBackgroundColor,
    this.appBrightness,
    this.textFieldColor,
    this.disabledTextFieldColor,
    this.appPrimaryColor,
    this.appAccentColor = Colors.amberAccent,
    this.appFontFamily = 'Roboto',
    this.appBarTitleFontSize = DefaultFontSize.appBarTitle,
    this.floatingWindowFontSize = DefaultFontSize.floatingWindowText,
  });

  VisualSettingState copyWith({
    final double titleFontSize,
    final Color titleColor,
    final double bodyFontSize,
    final Color bodyColor,
    final Color botIconColor,
    final Color botBackgroundColor,
    final Color categoryBackgroundColor,
    final Color categoryIconColor,
    final Color iconColor,
    final Color messageUnselectedColor,
    final Color messageSelectedColor,
    final Color dateTimeModeButtonBackgroundColor,
    final Color dateTimeModeButtonIconColor,
    final Color textFieldColor,
    final Color disabledTextFieldColor,
    final Color labelDateBackgroundColor,
    final Color helpWindowBackgroundColor,
    final Brightness appBrightness,
    final Color appPrimaryColor,
    final Color appAccentColor,
    final String appFontFamily,
    final double appBarTitleFontSize,
    final double floatingWindowFontSize,
  }) {
    return VisualSettingState(
      titleFontSize: titleFontSize ?? this.titleFontSize,
      titleColor: titleColor ?? this.titleColor,
      bodyFontSize: bodyFontSize ?? this.bodyFontSize,
      bodyColor: bodyColor ?? this.bodyColor,
      botIconColor: botIconColor ?? this.botIconColor,
      botBackgroundColor: botBackgroundColor ?? this.botBackgroundColor,
      categoryBackgroundColor:
      categoryBackgroundColor ?? this.categoryBackgroundColor,
      categoryIconColor: categoryIconColor ?? this.categoryIconColor,
      iconColor: iconColor ?? this.iconColor,
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
      textFieldColor: textFieldColor ?? this.textFieldColor,
      disabledTextFieldColor: disabledTextFieldColor ?? this.disabledTextFieldColor,
      appBrightness: appBrightness ?? this.appBrightness,
      appPrimaryColor: appPrimaryColor ?? this.appPrimaryColor,
      appAccentColor: appAccentColor ?? this.appAccentColor,
      appFontFamily: appFontFamily ?? this.appFontFamily,
      appBarTitleFontSize: appBarTitleFontSize ?? this.appBarTitleFontSize,
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
    floatingWindowFontSize,
    textFieldColor,
    disabledTextFieldColor,
  ];
}
