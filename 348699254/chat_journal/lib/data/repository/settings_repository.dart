import '../data_provider/shared_preferences_provider.dart';

class SettingsRepository {
  final SharedPreferencesProvider _pref;

  SettingsRepository(this._pref);

  bool fetchTheme() => _pref.fetchTheme();

  void changeTheme(bool isLight) => _pref.changeTheme(isLight);

  bool abilityChooseCategory() => _pref.abilityChooseCategory();

  void changeAbilityChooseCategory(bool isCategoryListOpen) =>
      _pref.changeAbilityChooseCategory(isCategoryListOpen);

  bool biometricAuth() => _pref.biometricAuth();

  void changeBiometricAuthAbility(bool isBiometricAuth) =>
      _pref.changeBiometricAuthAbility(isBiometricAuth);
}
