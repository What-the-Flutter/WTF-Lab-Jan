import 'package:flutter/cupertino.dart';

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
  late final MainAxisAlignment bubbleAlignment;

  ColorSet get colors => _colorSets[tColor.index];

  FontSizeSet get fontSize => _fontSizeSets[fSize.index];

  ThemeState({
    this.tColor = ThemeColor.light,
    this.fSize = FontSize.medium,
    this.bubbleAlignment = MainAxisAlignment.start,
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
    bubbleAlignment = MainAxisAlignment.values[Preferences.data?.getInt('bubble_align') ?? 0];
  }

  ThemeState duplicate({
    ThemeColor? tColor,
    FontSize? fSize,
    MainAxisAlignment? bubbleAlignment,
  }) {
    return ThemeState(
      tColor: tColor ?? this.tColor,
      fSize: fSize ?? this.fSize,
      bubbleAlignment: bubbleAlignment ?? this.bubbleAlignment,
      colorSets: _colorSets,
      fontSizeSets: _fontSizeSets,
    );
  }
}
