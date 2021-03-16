import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../custom_shared_preferences/custom_shared_preferences.dart';
import 'setting_screen_event.dart';
import 'settings_screen_state.dart';

class SettingScreenBloc extends Bloc<SettingScreenEvent, SettingsScreenState> {
  SettingScreenBloc(SettingsScreenState initialState) : super(initialState);

  @override
  Stream<SettingsScreenState> mapEventToState(SettingScreenEvent event) async* {
    if (event is ChangeBubbleAlignmentEvent) {
      yield* _mapChangeBubbleAlignmentToState();
    } else if (event is InitSettingScreenEvent) {
      yield* _mapInitSettingScreenToState();
    } else if (event is ChangeDateTimeModificationEvent) {
      yield* _mapChangeDateTimeModificationToState();
    } else if (event is ChangeFontSizeEvent) {
      yield* _mapChangeFontSizeEventToState(event);
    } else if (event is ResetSettingsEvent) {
      yield* _mapResetSettingsEventToState();
    }
  }

  Stream<SettingsScreenState> _mapInitSettingScreenToState() async* {
    final bubbleAlignment =
        await CustomSharedPreferences.sharedPrefInitBubbleAlignment();
    final dateTimeModification =
        await CustomSharedPreferences.sharedPrefInitDateTimeModification();
    final fontSize = await CustomSharedPreferences.sharedPrefInitFontSize();
    yield state.copyWith(
      isLeftBubbleAlignment: bubbleAlignment,
      isDateTimeModification: dateTimeModification,
      fontSize: fontSize,
    );
  }

  Stream<SettingsScreenState> _mapChangeBubbleAlignmentToState() async* {
    final bubbleAlignment = state.isLeftBubbleAlignment ? false : true;
    CustomSharedPreferences.sharedPrefChangeBubbleAlignment(bubbleAlignment);
    yield state.copyWith(isLeftBubbleAlignment: bubbleAlignment);
  }

  Stream<SettingsScreenState> _mapChangeDateTimeModificationToState() async* {
    final dateTimeModification = state.isDateTimeModification ? false : true;
    CustomSharedPreferences.sharedPrefChangeDateTimeModification(
        dateTimeModification);
    yield state.copyWith(isDateTimeModification: dateTimeModification);
  }

  Stream<SettingsScreenState> _mapChangeFontSizeEventToState(
      ChangeFontSizeEvent event) async* {
    final fontSize = event.selectedFontSize;
    CustomSharedPreferences.sharedPrefChangeFontSize(fontSize);
    yield state.copyWith(fontSize: fontSize);
  }

  Stream<SettingsScreenState> _mapResetSettingsEventToState() async* {
    CustomSharedPreferences.sharedPrefResetSettings();
    yield state.copyWith(
      isDateTimeModification: false,
      isLeftBubbleAlignment: false,
      fontSize: 1,
    );
  }
}
