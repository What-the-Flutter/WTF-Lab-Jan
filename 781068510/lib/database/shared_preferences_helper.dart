import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class ThemePreferences {
  static SharedPreferences? _preferences;
  static const _keyTheme = 'themeNumber';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future<int> getIntFromSharedPrefs() async{
    final themeNumber = _preferences!.getInt(_keyTheme);
    if (themeNumber == null) {
      return 0;
    }
    return themeNumber;
  }

  static Future<void> setTheme(int value) async{
    await _preferences!.setInt(_keyTheme, value);
  }

}