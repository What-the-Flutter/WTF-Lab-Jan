import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  static SharedPreferencesProvider? _sharedPreferencesProvider;
  static SharedPreferences? _preferences;

  SharedPreferencesProvider._createInstance();

  static const _keyTheme = 'isDarkMode';
  static const _keyDateTimeModification = 'isDateTimeModification';
  static const _keyBubbleAlignment = 'isBubbleAlignment';
  static const _keyCenterDateBubble = 'isCenterDateBubble';

  factory SharedPreferencesProvider() => _sharedPreferencesProvider ??=
      SharedPreferencesProvider._createInstance();

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  void changeTheme(bool value) => _preferences!.setBool(_keyTheme, value);

  bool getTheme() => _preferences!.getBool(_keyTheme) ?? true;

  void changeDateTimeMode(bool value) =>
      _preferences!.setBool(_keyDateTimeModification, value);

  bool getDateTimeMode() =>
      _preferences!.getBool(_keyDateTimeModification) ?? true;

  void changeBubbleAlignment(bool value) =>
      _preferences!.setBool(_keyBubbleAlignment, value);

  bool getBubbleAlignment() =>
      _preferences!.getBool(_keyBubbleAlignment) ?? true;

  void changeCenterDateBubble(bool value) =>
      _preferences!.setBool(_keyCenterDateBubble, value);

  bool getCenterDateBubble() =>
      _preferences!.getBool(_keyCenterDateBubble) ?? true;
}
