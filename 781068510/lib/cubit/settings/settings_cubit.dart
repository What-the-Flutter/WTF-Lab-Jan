import 'package:bloc/bloc.dart';
import '../../database/shared_preferences_helper.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<GeneralSettingsStates> {
  SettingsCubit() : super(GeneralSettingsStates());

  void getState() {
    emit(
      state.copyWith(
        isDateTimeModification: SharedPreferencesProvider().getDateTimeMode(),
        isBubbleAlignment: SharedPreferencesProvider().getBubbleAlignment(),
        isCenterDateBubble: SharedPreferencesProvider().getCenterDateBubble(),
      ),
    );
  }

  void resetAllPreferences() {
    SharedPreferencesProvider().changeDateTimeMode(false);
    SharedPreferencesProvider().changeBubbleAlignment(false);
    SharedPreferencesProvider().changeCenterDateBubble(false);
    getState();
  }

  void changeDateTimeModification() {
    SharedPreferencesProvider()
        .changeDateTimeMode(!state.isDateTimeModification);
    emit(
      state.copyWith(isDateTimeModification: !state.isDateTimeModification),
    );
    print(state.isDateTimeModification);
  }

  void changeBubbleAlignment() {
    SharedPreferencesProvider().changeBubbleAlignment(!state.isBubbleAlignment);
    emit(
      state.copyWith(isBubbleAlignment: !state.isBubbleAlignment),
    );
  }

  void changeCenterDateBubble() {
    SharedPreferencesProvider()
        .changeCenterDateBubble(!state.isCenterDateBubble);
    emit(
      state.copyWith(isCenterDateBubble: !state.isCenterDateBubble),
    );
  }
}
