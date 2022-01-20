import 'package:shared_preferences/shared_preferences.dart';

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

  bool getTheme() {
    return _prefs.getBool('isLight') ?? true;
  }
}
