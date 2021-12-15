import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  //TODO late final
  static const SharedPreferencesProvider _sharedPreferencesProvider =
      SharedPreferencesProvider._createInstance();

  static late final SharedPreferences _prefs;

  //SharedPreferences? _prefs;

  const SharedPreferencesProvider._createInstance();

  factory SharedPreferencesProvider() {
    return _sharedPreferencesProvider;
  }

  //In constructor
  static Future<void> initialize() async =>
      _prefs = await SharedPreferences.getInstance();

  bool fetchTheme() => _prefs.getBool('isLight') ?? true;

  void changeTheme(bool isLight) => _prefs.setBool('isLight', isLight);

  bool abilityChooseCategory() => _prefs.getBool('isCategoryListOpen') ?? true;

  void changeAbilityChooseCategory(bool isCategoryListOpen) =>
      _prefs.setBool('isCategoryListOpen', isCategoryListOpen);

  bool biometricAuth() => _prefs.getBool('isBiometricAuth') ?? true;

  void changeBiometricAuthAbility(bool isBiometricAuth) =>
      _prefs.setBool('isBiometricAuth', isBiometricAuth);
}
