import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/shared_preferences_provider.dart';

import 'states_general_settings.dart';

class CubitGeneralSettings extends Cubit<StatesGeneralSettings> {
  CubitGeneralSettings() : super(StatesGeneralSettings());

  void init() {
    emit(
      state.copyWith(
        isDateTimeModification:
            SharedPreferencesProvider().fetchDateTimeModification(),
        isCenterDateBubble: SharedPreferencesProvider().fetchCenterDateBubble(),
        isBubbleAlignment: SharedPreferencesProvider().fetchBubbleAlignment(),
      ),
    );
  }

  void resetAllPreferences() {
    if (state.isBubbleAlignment) {
      changeBubbleAlignment();
    }
    if (state.isDateTimeModification) {
      changeDateTimeModification();
    }
    if (state.isCenterDateBubble) {
      changeCenterDateBubble();
    }
  }

  void changeDateTimeModification() {
    SharedPreferencesProvider()
       .changeDateTimeModification(!state.isDateTimeModification);
    emit(state.copyWith(isDateTimeModification: !state.isDateTimeModification));
  }

  void changeBubbleAlignment() {
    SharedPreferencesProvider().changeBubbleAlignment(!state.isBubbleAlignment);
    emit(state.copyWith(isBubbleAlignment: !state.isBubbleAlignment));
  }

  void changeCenterDateBubble() {
    SharedPreferencesProvider()
       .changeCenterDateBubble(!state.isCenterDateBubble);
    emit(state.copyWith(isCenterDateBubble: !state.isCenterDateBubble));
  }
}
