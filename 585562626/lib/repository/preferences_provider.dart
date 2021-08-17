import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider {
  PreferencesProvider._();

  static final PreferencesProvider prefsProvider = PreferencesProvider._();
  static SharedPreferences? _prefs;
  static final String themeKey = 'app_theme';
  static final String biometricsLockKey = 'biometrics_lock';
  static final String bubbleAlignmentKey = 'bubble_alignment';
  static final String dateTimeModificationKey = 'date_time_modification';

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) {
      return _prefs!;
    }
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<bool> isDarkTheme() async {
    final prefs = await this.prefs;
    return prefs.getBool(themeKey) ?? false;
  }

  void saveTheme(bool isDarkTheme) async {
    final prefs = await this.prefs;
    prefs.setBool(themeKey, isDarkTheme);
  }

  Future<bool> biometricsLockEnabled() async {
    final prefs = await this.prefs;
    return prefs.getBool(biometricsLockKey) ?? false;
  }

  void saveBiometricsMode(bool enabled) async {
    final prefs = await this.prefs;
    prefs.setBool(biometricsLockKey, enabled);
  }

  Future<bool> bubbleAlignment() async {
    final prefs = await this.prefs;
    return prefs.getBool(bubbleAlignmentKey) ?? false;
  }

  void saveBubbleAlignment(bool enabled) async {
    final prefs = await this.prefs;
    prefs.setBool(bubbleAlignmentKey, enabled);
  }

  Future<bool> dateTimeModificationEnabled() async {
    final prefs = await this.prefs;
    return prefs.getBool(dateTimeModificationKey) ?? false;
  }

  void saveDateTimeModification(bool enabled) async {
    final prefs = await this.prefs;
    prefs.setBool(dateTimeModificationKey, enabled);
  }
}
