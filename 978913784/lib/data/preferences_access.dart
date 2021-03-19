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

  void saveTheme(bool usingLightTheme) =>
      _prefs.setBool('usingLightTheme', usingLightTheme);

  void saveRightToLeft(bool isRightToLeft) =>
    _prefs.setBool('isRightToLeft', isRightToLeft);

  void saveDateCentered(bool isDateCentered) =>
    _prefs.setBool('isDateCentered', isDateCentered);

  bool fetchTheme() => _prefs.getBool('usingLightTheme') ?? true;

  bool fetchRightToLeft() => _prefs.getBool('isRightToLeft') ?? false;

  bool fetchDateCentered() => _prefs.getBool('isDateCentered') ?? false;

}
