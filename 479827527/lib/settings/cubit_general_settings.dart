import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/shared_preferences_provider.dart';
import 'states_general_settings.dart';

class CubitGeneralSettings extends Cubit<StatesGeneralSettings> {
  CubitGeneralSettings(state) : super(state);

  void initSharedPreferences() {
    state.isDateTimeModification =
        SharedPreferencesProvider().fetchDateTimeModification();
    state.isBubbleAlignment =
        SharedPreferencesProvider().fetchBubbleAlignment();
    state.isCenterDateBubble =
        SharedPreferencesProvider().fetchCenterDateBubble();
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
