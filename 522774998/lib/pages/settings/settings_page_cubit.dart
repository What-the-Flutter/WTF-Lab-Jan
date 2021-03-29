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
      ),
    );
    emit(state.copyWith(
      isDateModificationSwitched: _preferences.fetchDateModification(),
      isBubbleAlignmentSwitched: _preferences.fetchBubbleAlignment(),
      isDateAlignmentSwitched: _preferences.fetchDateAlignment(),
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
}
