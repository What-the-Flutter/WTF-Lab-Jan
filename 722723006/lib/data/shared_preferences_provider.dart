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

  void changeBubbleAlignmentState(bool isBubbleAlignment) {
    _prefs.setBool('isBubbleAlignment', isBubbleAlignment);
  }

  bool fetchBubbleAlignmentState() {
    return _prefs.getBool('isBubbleAlignment') ?? false;
  }

  void changeDateTimeModificationState(bool isDateTimeModification) {
    _prefs.setBool('isDateTimeModification', isDateTimeModification);
  }

  bool fetchDateTimeModificationState() {
    return _prefs.getBool('isDateTimeModification') ?? false;
  }

  void changeCenterDateBubbleState(bool isCenterDateBubble) {
    _prefs.setBool('isCenterDateBubble', isCenterDateBubble);
  }

  bool fetchCenterDateBubbleState() {
    return _prefs.getBool('isCenterDateBubble') ?? false;
  }

  bool fetchTheme() {
    return _prefs.getBool('isLightTheme') ?? true;
  }
}
