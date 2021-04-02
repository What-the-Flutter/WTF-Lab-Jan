import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../preferences.dart';

part 'settings_page_state.dart';

class SettingPageCubit extends Cubit<SettingsPageState> {
  SharedPreferences _settingsPreferences;
  final _preferences = Preferences();

  SettingPageCubit(SettingsPageState state) : super(state);

  void initialize() async {
    var prefs = await SharedPreferences.getInstance();
    emit(
      state.copyWith(
        isDateModificationSwitched:
            prefs.getBool('isDateModificationSwitched') ?? false,
        isBubbleAlignmentSwitched:
            prefs.getBool('isBubbleAlignmentSwitched') ?? false,
        isDateAlignmentSwitched:
            prefs.getBool('isDateAlignmentSwitched') ?? false,
        fontSize: prefs.getDouble('fontSize' ?? 12),
        indexBackground: prefs.getInt('indexBackground' ?? 0),
      ),
    );
    emit(state.copyWith(
      isDateModificationSwitched: _preferences.fetchDateModification(),
      isBubbleAlignmentSwitched: _preferences.fetchBubbleAlignment(),
      isDateAlignmentSwitched: _preferences.fetchDateAlignment(),
      fontSize: _preferences.fetchFontSize(),
      indexBackground: _preferences.fetchIndexBackground(),
    ));
  }

  void changeDateModification(bool isDateModificationSwitched) {
    _preferences.saveDateModification(isDateModificationSwitched);
    emit(
        state.copyWith(isDateModificationSwitched: isDateModificationSwitched));
  }

  void changeBubbleAlignment(bool isBubbleAlignmentSwitched) {
    _preferences.saveBubbleAlignment(isBubbleAlignmentSwitched);
    emit(state.copyWith(isBubbleAlignmentSwitched: isBubbleAlignmentSwitched));
  }

  void changeDateAlignment(bool isDateAlignmentSwitched) {
    _preferences.saveDateAlignment(isDateAlignmentSwitched);
    emit(state.copyWith(isDateAlignmentSwitched: isDateAlignmentSwitched));
  }

  void changeFontSize(double fontSize) {
    _preferences.saveFontSize(fontSize);
    emit(state.copyWith(fontSize: fontSize));
  }

  void changeIndexBackground(int index) {
    _preferences.saveIndexBackground(index);
    emit(state.copyWith(indexBackground: index));
  }

  void reset() async {
    _preferences.saveFontSize(16);
    _preferences.saveDateAlignment(false);
    _preferences.saveBubbleAlignment(false);
    _preferences.saveDateModification(false);
    await _preferences.saveTheme(true);
    _preferences.saveIndexBackground(0);
    emit(
      state.copyWith(
        fontSize: 16,
        isBubbleAlignmentSwitched: false,
        isDateAlignmentSwitched: false,
        isDateModificationSwitched: false,
        indexBackground: 0,
      ),
    );
  }
}
