import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'setting_screen_event.dart';
import 'settings_screen_state.dart';

class SettingScreenBloc extends Bloc<SettingScreenEvent, SettingsScreenState> {
  static const _keyBubbleAlignment = 'bubbleAlignment';
  static const _keyDateTimeModification = 'DateTimeModification';

  SettingScreenBloc(SettingsScreenState initialState) : super(initialState);

  @override
  Stream<SettingsScreenState> mapEventToState(SettingScreenEvent event) async* {
    if (event is ChangeBubbleAlignmentEvent) {
      yield* _mapChangeBubbleAlignmentToState();
    } else if (event is InitSettingScreenEvent) {
      yield* _mapInitSettingScreenToState();
    } else if (event is ChangeDateTimeModificationEvent) {
      yield* _mapChangeDateTimeModificationToState();
    }
  }

  Stream<SettingsScreenState> _mapInitSettingScreenToState() async* {
    final pref = await SharedPreferences.getInstance();
    var bubbleAlignment = await pref.getBool(_keyBubbleAlignment) ?? false;
    var dateTimeModification =
        await pref.getBool(_keyDateTimeModification) ?? false;
    yield state.copyWith(
        isLeftBubbleAlignment: bubbleAlignment,
        isDateTimeModification: dateTimeModification);
  }

  Stream<SettingsScreenState> _mapChangeBubbleAlignmentToState() async* {
    final bubbleAlignment = state.isLeftBubbleAlignment ? false : true;
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_keyBubbleAlignment, bubbleAlignment);
    yield state.copyWith(isLeftBubbleAlignment: bubbleAlignment);
  }

  Stream<SettingsScreenState> _mapChangeDateTimeModificationToState() async* {
    final dateTimeModification = state.isDateTimeModification ? false : true;
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_keyDateTimeModification, dateTimeModification);
    yield state.copyWith(isDateTimeModification: dateTimeModification);
  }
}
