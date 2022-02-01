import '../../database/preferences.dart';

import '../../entity/theme.dart';

enum ThemeColor {
  light,
  dark,
}

class ThemeState {
  static final Object _plug = Object();

  late final List<ColorSet> _colorSets;
  late final ThemeColor tColor;

  ColorSet get colors => _colorSets[tColor.index];

  ThemeState({this.tColor = ThemeColor.light, List<ColorSet>? colorSets}) {
    _colorSets = colorSets ?? [];
  }

  ThemeState.initial() {
    _colorSets = [];
    _colorSets.add(ColorSet.lightDefault());
    _colorSets.add(ColorSet.darkDefault());
    tColor = ThemeColor.values[Preferences.data?.getInt('theme') ?? 0];
  }

  ThemeState duplicate({ThemeColor? tColor}) {
    return ThemeState(
      tColor: tColor ?? this.tColor,
      colorSets: _colorSets,
    );
  }
}
