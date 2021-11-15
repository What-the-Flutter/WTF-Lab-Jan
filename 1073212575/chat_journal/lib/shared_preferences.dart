import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  SharedPreferences? _prefs;

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void resetSettings() {
    changeTheme('light');
    changeCategoryPanelVisibility(true);
    changeCustomDateUsage(true);
    changeBiometricsUsage(false);
    changeMessageAlignment('left');
    changeDateAlignment('left');
    changeFontSize(16);
  }

  Future<String> theme() async {
    await _initPrefs();
    final savedTheme = _prefs!.getString('theme') ?? 'light';
    return savedTheme;
  }

  Future<int> fontSize() async {
    await _initPrefs();
    final fontSize = _prefs!.getInt('fontSize') ?? 16;
    return fontSize;
  }

  Future<bool> biometricsUsage() async {
    await _initPrefs();
    final useBiometrics = _prefs!.getBool('useBiometrics') ?? false;
    return useBiometrics;
  }

  Future<bool> categoryPanelVisibility() async {
    await _initPrefs();
    final categoryPanelVisibility =
        _prefs!.getBool('categoryPanelVisibility') ?? true;
    return categoryPanelVisibility;
  }

  Future<bool> customDateUsage() async {
    await _initPrefs();
    final customDateUsage = _prefs!.getBool('isCustomDateUsed') ?? true;
    return customDateUsage;
  }

  Future<String> messageAlignment() async {
    await _initPrefs();
    final savedMessageAlignment =
        _prefs!.getString('messageAlignment') ?? 'left';
    return savedMessageAlignment;
  }

  Future<String> dateAlignment() async {
    await _initPrefs();
    final savedDateAlignment = _prefs!.getString('dateAlignment') ?? 'left';
    return savedDateAlignment;
  }

  void changeTheme(String savedTheme) async {
    await _initPrefs();
    _prefs!.setString('theme', savedTheme);
  }

  void changeFontSize(int chosenFontSize) async {
    await _initPrefs();
    _prefs!.setInt('fontSize', chosenFontSize);
  }

  void changeCategoryPanelVisibility(bool isCategoryPanelVisible) async {
    await _initPrefs();
    _prefs!.setBool('categoryPanelVisibility', isCategoryPanelVisible);
  }

  void changeBiometricsUsage(bool useBiometrics) async {
    await _initPrefs();
    _prefs!.setBool('useBiometrics', useBiometrics);
  }

  void changeCustomDateUsage(bool isCustomDateUsed) async {
    await _initPrefs();
    _prefs!.setBool('isCustomDateUsed', isCustomDateUsed);
  }

  void changeMessageAlignment(String messageAlignment) async {
    await _initPrefs();
    _prefs!.setString('messageAlignment', messageAlignment);
  }

  void changeDateAlignment(String savedDateAlignment) async {
    await _initPrefs();
    _prefs!.setString('dateAlignment', savedDateAlignment);
  }

  bool useBiometrics() {
    return _prefs!.getBool('useBiometrics') ?? false;
  }
}
