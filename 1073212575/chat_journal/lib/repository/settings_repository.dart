import '../shared_preferences.dart';

class SettingsRepository {
  final SharedPreferencesProvider _provider;

  SettingsRepository(this._provider);

  void resetSettings() {
    return _provider.resetSettings();
  }

  Future<String> theme() {
    return _provider.theme();
  }

  Future<int> fontSize() {
    return _provider.fontSize();
  }

  Future<bool> biometricsUsage() {
    return _provider.biometricsUsage();
  }

  Future<bool> categoryPanelVisibility() {
    return _provider.categoryPanelVisibility();
  }

  Future<bool> customDateUsage() {
    return _provider.customDateUsage();
  }

  Future<String> messageAlignment() {
    return _provider.messageAlignment();
  }

  Future<String> dateAlignment() {
    return _provider.dateAlignment();
  }

  void changeTheme(String savedTheme) {
    _provider.changeTheme(savedTheme);
  }

  void changeFontSize(int chosenFontSize) {
    _provider.changeFontSize(chosenFontSize);
  }

  void changeCategoryPanelVisibility(bool isCategoryPanelVisible) {
    _provider.changeCategoryPanelVisibility(isCategoryPanelVisible);
  }

  void changeBiometricsUsage(bool useBiometrics) {
    _provider.changeBiometricsUsage(useBiometrics);
  }

  void changeCustomDateUsage(bool isCustomDateUsed) {
    _provider.changeCustomDateUsage(isCustomDateUsed);
  }

  void changeMessageAlignment(String messageAlignment) {
    _provider.changeMessageAlignment(messageAlignment);
  }

  void changeDateAlignment(String savedDateAlignment) {
    _provider.changeDateAlignment(savedDateAlignment);
  }

  bool useBiometrics() {
    return _provider.useBiometrics();
  }
}
