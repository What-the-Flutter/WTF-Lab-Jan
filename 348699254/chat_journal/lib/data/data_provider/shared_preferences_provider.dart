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

  bool fetchTheme() => _prefs.getBool('isLight') ?? true;

  void changeTheme(bool isLight) => _prefs.setBool('isLight', isLight);

  bool abilityChooseCategory() => _prefs.getBool('isCategoryListOpen') ?? true;

  void changeAbilityChooseCategory(bool isCategoryListOpen) =>
      _prefs.setBool('isCategoryListOpen', isCategoryListOpen);

  bool isRightBubbleAlignment() =>
      _prefs.getBool('isRightBubbleAlignment') ?? true;

  void changeBubbleAlignment(bool isRightBubbleAlignment) =>
      _prefs.setBool('isRightBubbleAlignment', isRightBubbleAlignment);

  double fetchFontSize() => _prefs.getDouble('fontSize') ?? 16;

  void changeFontSize(double fontSize) =>
      _prefs.setDouble('fontSize', fontSize);

  bool biometricAuth() => _prefs.getBool('isBiometricAuth') ?? true;

  void changeBiometricAuthAbility(bool isBiometricAuth) =>
      _prefs.setBool('isBiometricAuth', isBiometricAuth);

  void resetAllSettings() {
    changeTheme(true);
    changeAbilityChooseCategory(true);
    changeBubbleAlignment(true);
    changeFontSize(16);
    changeBiometricAuthAbility(true);
  }
}
