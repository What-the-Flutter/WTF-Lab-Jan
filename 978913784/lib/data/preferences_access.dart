import 'package:shared_preferences/shared_preferences.dart';

class PreferencesAccess {
  static final _preferencesAccess = PreferencesAccess._internal();
  static SharedPreferences _prefs;

  factory PreferencesAccess() {
    return _preferencesAccess;
  }

  PreferencesAccess._internal();

  static void initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveTheme(bool usingLightTheme) async =>
      await _prefs.setBool('usingLightTheme', usingLightTheme);

  void saveRightToLeft(bool isRightToLeft) =>
    _prefs.setBool('isRightToLeft', isRightToLeft);

  void saveDateCentered(bool isDateCentered) =>
    _prefs.setBool('isDateCentered', isDateCentered);

  int saveFontSize(int sizeIndex) {
    var index;
    if (sizeIndex == -1) {
      index = 0;
    } else if (sizeIndex == 0) {
      index = 1;
    } else {
      index = -1;
    }
    _prefs.setInt('sizeIndex', index);
    return index;
  }

  bool fetchTheme() => _prefs.getBool('usingLightTheme') ?? true;

  bool fetchRightToLeft() => _prefs.getBool('isRightToLeft') ?? false;

  bool fetchDateCentered() => _prefs.getBool('isDateCentered') ?? false;

  int fetchFontSize() => _prefs.getInt('sizeIndex') ?? 0;

}
