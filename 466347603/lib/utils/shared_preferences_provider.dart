import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  static late final bool _isDarkMode;

  static bool get isDarkMode => _isDarkMode;

  SharedPreferencesProvider._(bool isDarkMode) {
    _isDarkMode = isDarkMode;
  }

  static Future<SharedPreferencesProvider> init() async =>
      SharedPreferencesProvider._(await fetchThemeMode());

  static void saveThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  ///returns [true] on dark theme mode, [false] on light theme mode
  static Future<bool> fetchThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkMode') ?? false;
  }
}
