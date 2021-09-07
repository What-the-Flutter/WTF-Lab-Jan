import 'package:shared_preferences/shared_preferences.dart';
//поля вынести в конст тут и в дбпровайд
class SharedPreferencesProvider {
  static const SharedPreferencesProvider _sharedPreferencesProvider =
  SharedPreferencesProvider._createInstance();
  static late final SharedPreferences _prefs;

  const SharedPreferencesProvider._createInstance();

  factory SharedPreferencesProvider() {
    return _sharedPreferencesProvider;
  }

  static Future<void> initialize() async =>
      _prefs = await SharedPreferences.getInstance();

  void changeTheme(bool isLight) => _prefs.setBool('isLight', isLight);

  bool fetchTheme() {
    return _prefs.getBool('isLight') ?? true;
  }

  void changeBubbleAlignment(bool isBubbleAlignment) =>
      _prefs.setBool('isBubbleAlignment', isBubbleAlignment);

  bool fetchBubbleAlignment() {
    return _prefs.getBool('isBubbleAlignment') ?? false;
  }

  void changeDateTimeModification(bool isDateTimeModification) =>
      _prefs.setBool('isDateTimeModification', isDateTimeModification);

  bool fetchDateTimeModification() {
    return _prefs.getBool('isDateTimeModification') ?? false;
  }

  void changeCenterDateBubble(bool isCenterDateBubble) =>
      _prefs.setBool('isCenterDateBubble', isCenterDateBubble);

  bool fetchCenterDateBubble() {
    return _prefs.getBool('isCenterDateBubble') ?? false;
  }

  void changeFontSizeIndex(int fontSizeIndex) =>
      _prefs.setInt('fontSizeIndex', fontSizeIndex);

  int fetchFontSizeIndex() {
    return _prefs.getInt('fontSizeIndex') ?? 1;
  }


}