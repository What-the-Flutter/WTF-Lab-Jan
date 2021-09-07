import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/shared_preferences_provider.dart';

part 'general_settings_state.dart';

class GeneralSettingsCubit extends Cubit<GeneralSettingsState> {

  final SharedPreferencesProvider _prefs = SharedPreferencesProvider();

  GeneralSettingsCubit() : super(GeneralSettingsState());

  void initStates() {
    emit(
      state.copyWith(
        isDateTimeModification: _prefs.fetchDateTimeModification(),
        isCenterDateBubble: _prefs.fetchCenterDateBubble(),
        isBubbleAlignment: _prefs.fetchBubbleAlignment(),
      ),
    );
  }

  void setCenterDateBubbleState(bool isCenterDateBubble) {
    _prefs.changeCenterDateBubble(isCenterDateBubble);
    emit(state.copyWith(isCenterDateBubble: isCenterDateBubble));
  }

  void setDateTimeModificationState(bool isDateTimeModification) {
    _prefs.changeDateTimeModification(isDateTimeModification);
    emit(state.copyWith(isDateTimeModification: isDateTimeModification));
  }

  void resetAllPreferences() {
    _prefs.changeTheme(true);
    _prefs.changeDateTimeModification(false);
    _prefs.changeBubbleAlignment(false);
    _prefs.changeCenterDateBubble(false);
    emit(
      state.copyWith(
        isCenterDateBubble: false,
        isDateTimeModification: false,
        isBubbleAlignment: false,
      ),
    );
  }

  void setBubbleAlignmentState(bool isBubbleAlignment) {
    _prefs.changeBubbleAlignment(isBubbleAlignment);
    emit(state.copyWith(isBubbleAlignment: isBubbleAlignment));
  }
}