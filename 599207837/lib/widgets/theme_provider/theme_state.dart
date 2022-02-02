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

enum ChatBackground {
  empty,
  sakura,
  seoul,
  street,
  abstract,
  gurren,
  faye,
}

Map<ChatBackground, String> chatBackPath = {
  ChatBackground.sakura: 'assets/images/background/sakura.jpg',
  ChatBackground.street: 'assets/images/background/street.jpg',
  ChatBackground.seoul: 'assets/images/background/seoul.jpg',
  ChatBackground.abstract: 'assets/images/background/abstract.jpg',
  ChatBackground.gurren: 'assets/images/background/gurren.jpg',
  ChatBackground.faye: 'assets/images/background/faye.png',
};

class ThemeState {
  static final Object _plug = Object();

  late final List<ColorSet> _colorSets;
  late final List<FontSizeSet> _fontSizeSets;
  late final ThemeColor tColor;
  late final FontSize fSize;
  late final ChatBackground chBackground;

  late final MainAxisAlignment bubbleAlignment;

  ColorSet get colors => _colorSets[tColor.index];

  FontSizeSet get fontSize => _fontSizeSets[fSize.index];

  String? get backgroundPath => chatBackPath[chBackground];

  ThemeState({
    this.tColor = ThemeColor.light,
    this.fSize = FontSize.medium,
    this.bubbleAlignment = MainAxisAlignment.start,
    this.chBackground = ChatBackground.sakura,
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
    chBackground = ChatBackground.values[Preferences.data?.getInt('chat_back') ?? 0];
    bubbleAlignment = MainAxisAlignment.values[Preferences.data?.getInt('bubble_align') ?? 0];
  }

  ThemeState duplicate({
    ThemeColor? tColor,
    FontSize? fSize,
    ChatBackground? chBackground,
    MainAxisAlignment? bubbleAlignment,
  }) {
    return ThemeState(
      tColor: tColor ?? this.tColor,
      fSize: fSize ?? this.fSize,
      chBackground: chBackground ?? this.chBackground,
      bubbleAlignment: bubbleAlignment ?? this.bubbleAlignment,
      colorSets: _colorSets,
      fontSizeSets: _fontSizeSets,
    );
  }
}
