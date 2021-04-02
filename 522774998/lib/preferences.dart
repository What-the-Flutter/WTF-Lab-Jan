import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final _preferences = Preferences._internal();
  static SharedPreferences _prefs;

  factory Preferences() {
    return _preferences;
  }

  Preferences._internal();

  static void initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveTheme(bool isLightTheme) async =>
      await _prefs.setBool('isLightTheme', isLightTheme);

  void saveDateModification(bool isDateModificationSwitched) =>
      _prefs.setBool('isDateModificationSwitched', isDateModificationSwitched);

  void saveBubbleAlignment(bool isBubbleCentered) =>
      _prefs.setBool('isBubbleAlignmentSwitched', isBubbleCentered);

  void saveDateAlignment(bool isBubbleCentered) =>
      _prefs.setBool('isDateAlignmentSwitched', isBubbleCentered);

  void saveFontSize(double fontSize) => _prefs.setDouble('fontSize', fontSize);

  void saveIndexBackground(int index) =>
      _prefs.setInt('indexBackground', index);

  bool fetchTheme() => _prefs.getBool('isLightTheme') ?? true;

  bool fetchDateModification() =>
      _prefs.getBool('isDateModificationSwitched') ?? false;

  bool fetchBubbleAlignment() =>
      _prefs.getBool('isBubbleAlignmentSwitched') ?? false;

  bool fetchDateAlignment() =>
      _prefs.getBool('isDateAlignmentSwitched') ?? false;

  double fetchFontSize() => _prefs.getDouble('fontSize') ?? 16.0;

  int fetchIndexBackground() => _prefs.getInt('indexBackground') ?? 0;
}
