import '../../database/preferences.dart';

import '../../entity/theme.dart';

enum ThemeColor {
  light,
  dark,
}

enum FontSize {
  small,
  medium,
  large,
}

class ThemeState {
  static final Object _plug = Object();

  late final List<ColorSet> _colorSets;
  late final List<FontSizeSet> _fontSizeSets;
  late final ThemeColor tColor;
  late final FontSize fSize;

  ColorSet get colors => _colorSets[tColor.index];

  FontSizeSet get fontSize => _fontSizeSets[fSize.index];

  ThemeState({
    this.tColor = ThemeColor.light,
    this.fSize = FontSize.medium,
    List<ColorSet>? colorSets,
    List<FontSizeSet>? fontSizeSets,
  }) {
    _colorSets = colorSets ?? [];
    _fontSizeSets = fontSizeSets ?? [];
  }

  ThemeState.initial() {
    _colorSets = [];
    _colorSets.add(ColorSet.lightDefault());
    _colorSets.add(ColorSet.darkDefault());
    _fontSizeSets = [];
    _fontSizeSets.add(FontSizeSet.small());
    _fontSizeSets.add(FontSizeSet.medium());
    _fontSizeSets.add(FontSizeSet.large());
    tColor = ThemeColor.values[Preferences.data?.getInt('theme') ?? 0];
    fSize = FontSize.values[Preferences.data?.getInt('font_size') ?? 1];
  }

  ThemeState duplicate({ThemeColor? tColor, FontSize? fSize}) {
    return ThemeState(
      tColor: tColor ?? this.tColor,
      fSize: fSize ?? this.fSize,
      colorSets: _colorSets,
      fontSizeSets: _fontSizeSets,
    );
  }
}
