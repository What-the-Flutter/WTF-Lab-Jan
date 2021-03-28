import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/preferences_access.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final _preferencesAccess = PreferencesAccess();

  SettingsCubit(SettingsState state) : super(state);

  void initialize() async {
    emit(
      state.copyWith(
        isRightToLeft: _preferencesAccess.fetchRightToLeft(),
        isDateCentered: _preferencesAccess.fetchDateCentered(),
        fontSizeIndex: _preferencesAccess.fetchFontSize(),
      ),
    );
  }

  void changeRightToLeft(bool isRightToLeft) {
    _preferencesAccess.saveRightToLeft(isRightToLeft);
    emit(state.copyWith(isRightToLeft: isRightToLeft));
  }

  void changeDateCentered(bool isDateCentered) {
    _preferencesAccess.saveDateCentered(isDateCentered);
    emit(state.copyWith(isDateCentered: isDateCentered));
  }

  void changeFontSize() {
    final index = _preferencesAccess.saveFontSize(state.fontSizeIndex);
    emit(state.copyWith(fontSizeIndex: index));
  }

  void reset() async {
    _preferencesAccess.saveFontSize(-1);
    _preferencesAccess.saveDateCentered(false);
    _preferencesAccess.saveRightToLeft(false);
    await _preferencesAccess.saveTheme(true);
    emit(
      state.copyWith(
        fontSizeIndex: 0,
        isRightToLeft: false,
        isDateCentered: false,
      ),
    );
  }

  static double calculateSize(
      BuildContext context, double val1, double val2, double val3) {
    return BlocProvider.of<SettingsCubit>(context).state.fontSizeIndex == -1
        ? val1
        : BlocProvider.of<SettingsCubit>(context).state.fontSizeIndex == 0
            ? val2
            : val3;
  }
}
