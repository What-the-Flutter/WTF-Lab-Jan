import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider {
  PreferencesProvider._();

  static final PreferencesProvider prefsProvider = PreferencesProvider._();
  static SharedPreferences? _prefs;
  static final String themeKey = 'app_theme';

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) {
      return _prefs!;
    }
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<bool> isDarkTheme() async {
    final prefs = await this.prefs;
    return prefs.getBool(themeKey) ?? false;
  }

  void saveTheme(bool isDarkTheme) async {
    final prefs = await this.prefs;
    prefs.setBool(themeKey, isDarkTheme);
  }
}
