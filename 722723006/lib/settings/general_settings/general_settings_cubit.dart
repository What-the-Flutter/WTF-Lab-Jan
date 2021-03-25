import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/shared_preferences_provider.dart';

part 'general_settings_states.dart';

class GeneralSettingsCubit extends Cubit<GeneralSettingsStates> {
  GeneralSettingsCubit(GeneralSettingsStates state) : super(state);

  void setCenterDateBubbleState(bool isCenterDateBubble) {
    SharedPreferencesProvider().changeCenterDateBubbleState(isCenterDateBubble);
    emit(state.copyWith(isCenterDateBubble: isCenterDateBubble));
  }

  void setThemeChangeState(bool isThemeChange) {
    SharedPreferencesProvider().changeTheme(isThemeChange);
    emit(state.copyWith(isThemeChange: isThemeChange));
  }

  void setDateTimeModificationState(bool isDateTimeModification) {
    SharedPreferencesProvider()
        .changeDateTimeModificationState(isDateTimeModification);
    emit(state.copyWith(isDateTimeModification: isDateTimeModification));
  }

  void setBubbleAlignmentState(bool isBubbleAlignment) {
    SharedPreferencesProvider().changeBubbleAlignmentState(isBubbleAlignment);
    emit(state.copyWith(isBubbleAlignment: isBubbleAlignment));
  }
}
