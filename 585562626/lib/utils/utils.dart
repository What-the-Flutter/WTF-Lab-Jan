import '../ui/pages/settings/bloc/bloc.dart';
import 'constants.dart';

final defaultFontSizeIndex = SettingsFontSize.normal.index;

extension ToFontSize on SettingsFontSize {
  double toFontSize() {
    switch (this) {
      case SettingsFontSize.small:
        return FontSize.small;
      case SettingsFontSize.medium:
        return FontSize.medium;
      case SettingsFontSize.normal:
        return FontSize.normal;
      case SettingsFontSize.big:
        return FontSize.big;
      case SettingsFontSize.large:
        return FontSize.large;
    }
  }

  double fontRatio() {
    final font;
    switch (this) {
      case SettingsFontSize.small:
        font = FontSize.small;
        break;
      case SettingsFontSize.medium:
        font = FontSize.medium;
        break;
      case SettingsFontSize.normal:
        font = FontSize.normal;
        break;
      case SettingsFontSize.big:
        font = FontSize.big;
        break;
      case SettingsFontSize.large:
        font = FontSize.large;
        break;
    }
    return font / FontSize.normal;
  }
}
