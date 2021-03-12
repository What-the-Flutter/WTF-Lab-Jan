import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(SettingsState state) : super(state);

  void initialize() async {
    var prefs = await SharedPreferences.getInstance();
    emit(state.copyWith(
      isDateCentered: prefs.getBool('isDateCentered') ?? false,
      isRightToLeft: prefs.getBool('isRightToLeft') ?? false,
    ));
  }

  void changeRightToLeft(bool isRightToLeft) async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('isRightToLeft', isRightToLeft);
    emit(state.copyWith(isRightToLeft: isRightToLeft));
  }

  void changeDateCentered(bool isDateCentered) async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDateCentered', isDateCentered);
    emit(state.copyWith(isDateCentered: isDateCentered));
  }
}
