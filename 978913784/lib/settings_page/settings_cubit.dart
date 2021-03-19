import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/preferences_access.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final _preferencesAccess = PreferencesAccess();

  SettingsCubit(SettingsState state) : super(state);

  void initialize() async {
    emit(state.copyWith(
      isRightToLeft: _preferencesAccess.fetchRightToLeft(),
      isDateCentered: _preferencesAccess.fetchDateCentered(),
    ));
  }

  void changeRightToLeft(bool isRightToLeft) async {
    _preferencesAccess.saveRightToLeft(isRightToLeft);
    emit(state.copyWith(isRightToLeft: isRightToLeft));
  }

  void changeDateCentered(bool isDateCentered) async {
    _preferencesAccess.saveDateCentered(isDateCentered);
    emit(state.copyWith(isDateCentered: isDateCentered));
  }
}
