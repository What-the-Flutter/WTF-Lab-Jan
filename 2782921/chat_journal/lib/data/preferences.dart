import 'package:shared_preferences/shared_preferences.dart';

class PreferenceData {
  static late SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveTheme(bool usingLightTheme) async =>
      await _prefs.setBool('useLightTheme', usingLightTheme);

  bool fetchTheme() => _prefs.getBool('useLightTheme') ?? true;
}
