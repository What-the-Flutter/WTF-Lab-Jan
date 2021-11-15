import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  static final SharedPreferencesProvider _sharedPreferencesProvider =
      SharedPreferencesProvider._createInstance();
  static late final SharedPreferences _prefs;

  SharedPreferencesProvider._createInstance();

  factory SharedPreferencesProvider() {
    return _sharedPreferencesProvider;
  }

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  addThemeModeToSF(bool isLight) async {
    _prefs.setBool('isLight', isLight);
  }

  getThemeModeSF() {
    return _prefs.getBool('isLight') ?? true;
  }
}
