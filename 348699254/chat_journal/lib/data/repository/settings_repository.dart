import '../data_provider/shared_preferences_provider.dart';

class SettingsRepository {
  final SharedPreferencesProvider _prefProvider;

  SettingsRepository(this._prefProvider);

  bool fetchTheme() => _prefProvider.fetchTheme();

  void changeTheme(bool isLight) => _prefProvider.changeTheme(isLight);

  bool abilityChooseCategory() => _prefProvider.abilityChooseCategory();

  void changeAbilityChooseCategory(bool isCategoryListOpen) =>
      _prefProvider.changeAbilityChooseCategory(isCategoryListOpen);

  bool isRightBubbleAlignment() => _prefProvider.isRightBubbleAlignment();

  void changeBubbleAlignment(bool isRightBubbleAlignment) =>
      _prefProvider.changeBubbleAlignment(isRightBubbleAlignment);

  double fetchFontSize() => _prefProvider.fetchFontSize();

  void changeFontSize(double fontSize) =>
      _prefProvider.changeFontSize(fontSize);

  bool biometricAuth() => _prefProvider.biometricAuth();

  void changeBiometricAuthAbility(bool isBiometricAuth) =>
      _prefProvider.changeBiometricAuthAbility(isBiometricAuth);

  void resetAllSettings() => _prefProvider.resetAllSettings();
}
