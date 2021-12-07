import '../data_provider/shared_preferences_provider.dart';

class SettingsRepository {
  final SharedPreferencesProvider _pref;

  SettingsRepository(this._pref);

  bool abilityChooseCategory() {
    return _pref.abilityChooseCategory();
  }

  void changeAbilityChooseCategory(bool isCategoryListOpen) {
    _pref.changeAbilityChooseCategory(isCategoryListOpen);
  }
}