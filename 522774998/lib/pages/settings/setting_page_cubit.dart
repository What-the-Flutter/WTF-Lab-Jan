import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'setting_page_state.dart';

class SettingPageCubit extends Cubit<SettingsPageState> {
  SharedPreferences _settingsPreferences;
  SettingPageCubit(SettingsPageState state) : super(state);

  void initialize() async {
    var prefs = await SharedPreferences.getInstance();
    emit(state.copyWith(
      isDateModificationSwitched: prefs.getBool('isDateModificationSwitched') ?? false,
      isBubbleAlignmentSwitched: prefs.getBool('isBubbleAlignmentSwitched') ?? false,
      isDateAlignmentSwitched: prefs.getBool('isDateAlignmentSwitched') ?? false,
    ));
  }

  void changeDateModification(bool isDateModificationSwitched) async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDateModificationSwitched', isDateModificationSwitched);
    emit(state.copyWith(isDateModificationSwitched: isDateModificationSwitched));
  }

  void changeBubbleAlignment(bool isBubbleAlignmentSwitched) async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('isBubbleAlignmentSwitched', isBubbleAlignmentSwitched);
    emit(state.copyWith(isBubbleAlignmentSwitched: isBubbleAlignmentSwitched));
  }

  void changeDateAlignment(bool isDateAlignmentSwitched) async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDateAlignmentSwitched', isDateAlignmentSwitched);
    emit(state.copyWith(isDateAlignmentSwitched: isDateAlignmentSwitched));
  }
}
