import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  static SharedPreferencesProvider? _sharedPreferencesProvider;
  static SharedPreferences? _prefs;

  SharedPreferencesProvider._createInstance();

  factory SharedPreferencesProvider() => _sharedPreferencesProvider ??=
      SharedPreferencesProvider._createInstance();

  static void initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void changeTheme(bool isLightTheme) =>
      _prefs?.setBool('isLightTheme', isLightTheme);

  bool fetchTheme() => _prefs?.getBool('isLightTheme') ?? true;

  void changeFontSize(int fontSize) => _prefs?.setInt('fontSize', fontSize);

  int fetchFontSize() => _prefs?.getInt('fontSize') ?? 2;

  void changeDateTimeModification(bool isDateTimeModification) =>
      _prefs?.setBool('isDateTimeModification', isDateTimeModification);

  bool fetchDateTimeModification() =>
      _prefs?.getBool('isDateTimeModification') ?? false;

  void changeBubbleAlignment(bool isBubbleAlignment) =>
      _prefs?.setBool('isBubbleAlignment', isBubbleAlignment);

  bool fetchBubbleAlignment() => _prefs?.getBool('isBubbleAlignment') ?? false;

  void changeCenterDateBubble(bool isCenterDateBubble) =>
      _prefs?.setBool('isCenterDateBubble', isCenterDateBubble);

  bool fetchCenterDateBubble() => _prefs?.getBool('isCenterDateBubble') ?? false;
}
