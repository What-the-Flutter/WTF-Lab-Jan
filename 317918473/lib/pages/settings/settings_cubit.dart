import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/shared_prefs.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(SettingsState(
          MySharedPreferences.sharedPrefs.isBubbleAlignment,
          MySharedPreferences.sharedPrefs.isCenterDateBubble,
          MySharedPreferences.sharedPrefs.isModifiedDate,
          MySharedPreferences.sharedPrefs.isBiometricAuth,
          SettingsStates.initial,
        ));

  void changeBubbleAlignment(bool value) {
    MySharedPreferences.sharedPrefs.setBubbleAlignment(value);
    emit(state.copyWith(
        isBubbleAlignment: value,
        settingsStates: SettingsStates.bubbleAlignment));
  }

  void changeCenterDateAlignmetnt(bool value) {
    MySharedPreferences.sharedPrefs.setCenterDateBubble(value);
    emit(state.copyWith(
        isCenterDateBubble: value,
        settingsStates: SettingsStates.centerDateBubble));
  }

  void changeModifiedDate(bool value) {
    MySharedPreferences.sharedPrefs.setModifiedDate(value);
    emit(state.copyWith(
        isModifiedDate: value, settingsStates: SettingsStates.modifyDate));
  }

  void changeBiometricAuth(bool value) {
    MySharedPreferences.sharedPrefs.setBiometricAuth(value);
    emit(state.copyWith(
        isBiometricAuth: value, settingsStates: SettingsStates.biometricAuth));
  }
}
