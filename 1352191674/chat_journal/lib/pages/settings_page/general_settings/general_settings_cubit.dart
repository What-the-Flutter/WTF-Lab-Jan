import 'package:chat_journal/services/shared_preferences_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'general_settings_state.dart';

class GeneralSettingsCubit extends Cubit<GeneralSettingsState> {
  GeneralSettingsCubit() : super(GeneralSettingsState());
  final _prefs = SharedPreferencesProvider();

  void initStates() {
    emit(
      state.copyWith(
        isDateTimeModification: _prefs.fetchDateTimeModificationState(),
        isCenterDateBubble: _prefs.fetchCenterDateBubbleState(),
        isBubbleAlignment: _prefs.fetchBubbleAlignmentState(),
      ),
    );
  }

  void setCenterDateBubbleState(bool isCenterDateBubble) {
    _prefs.changeCenterDateBubbleState(isCenterDateBubble);
    emit(state.copyWith(isCenterDateBubble: isCenterDateBubble));
  }

  void setDateTimeModificationState(bool isDateTimeModification) {
    _prefs.changeDateTimeModificationState(isDateTimeModification);
    emit(state.copyWith(isDateTimeModification: isDateTimeModification));
  }

  void resetAllPreferences() {
    _prefs.changeTheme(true);
    _prefs.changeDateTimeModificationState(false);
    _prefs.changeBubbleAlignmentState(false);
    _prefs.changeCenterDateBubbleState(false);
    emit(
      state.copyWith(
        isCenterDateBubble: false,
        isDateTimeModification: false,
        isBubbleAlignment: false,
      ),
    );
  }

  void setBubbleAlignmentState(bool isBubbleAlignment) {
    _prefs.changeBubbleAlignmentState(isBubbleAlignment);
    emit(state.copyWith(isBubbleAlignment: isBubbleAlignment));
  }
}