import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  static SharedPreferencesProvider _sharedPreferencesProvider;
  static SharedPreferences _prefs;

  SharedPreferencesProvider._createInstance();

  factory SharedPreferencesProvider() {
    _sharedPreferencesProvider ??= SharedPreferencesProvider._createInstance();
    return _sharedPreferencesProvider;
  }

  static void initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void changeTheme(bool isLightTheme) {
    _prefs.setBool('isLightTheme', isLightTheme);
  }

  bool fetchTheme() {
    return _prefs.getBool('isLightTheme') ?? true;
  }

  void changeDateTimeModification(bool isDateTimeModification) {
    _prefs.setBool('isDateTimeModification', isDateTimeModification);
  }

  bool fetchDateTimeModification() {
    return _prefs.getBool('isDateTimeModification') ?? false;
  }

  void changeBubbleAlignment(bool isBubbleAlignment) {
    _prefs.setBool('isBubbleAlignment', isBubbleAlignment);
  }

  bool fetchBubbleAlignment() {
    return _prefs.getBool('isBubbleAlignment') ?? false;
  }

  void changeCenterDateBubble(bool isCenterDateBubble) {
    _prefs.setBool('isCenterDateBubble', isCenterDateBubble);
  }

  bool fetchCenterDateBubble() {
    return _prefs.getBool('isCenterDateBubble') ?? false;
  }
}
