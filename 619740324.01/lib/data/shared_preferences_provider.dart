import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  static SharedPreferencesProvider? _sharedPreferencesProvider;
  static SharedPreferences? _prefs;

  SharedPreferencesProvider._createInstance();

  factory SharedPreferencesProvider() => _sharedPreferencesProvider ??=
      SharedPreferencesProvider._createInstance();

  static void initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void changeTheme(bool isLightTheme) =>
      _prefs?.setBool('isLightTheme', isLightTheme);

  bool fetchTheme() => _prefs?.getBool('isLightTheme') ?? true;
}
