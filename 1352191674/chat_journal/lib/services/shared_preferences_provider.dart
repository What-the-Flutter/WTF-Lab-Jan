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

  void changeBubbleAlignmentState(bool isBubbleAlignment) =>
      _prefs.setBool('isBubbleAlignment', isBubbleAlignment);

  bool fetchBubbleAlignmentState() {
    return _prefs.getBool('isBubbleAlignment') ?? false;
  }

  void changeDateTimeModificationState(bool isDateTimeModification) =>
      _prefs.setBool('isDateTimeModification', isDateTimeModification);

  bool fetchDateTimeModificationState() {
    return _prefs.getBool('isDateTimeModification') ?? false;
  }

  void changeCenterDateBubbleState(bool isCenterDateBubble) =>
      _prefs.setBool('isCenterDateBubble', isCenterDateBubble);

  bool fetchCenterDateBubbleState() {
    return _prefs.getBool('isCenterDateBubble') ?? false;
  }
}