import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'setting_screen_event.dart';
import 'settings_screen_state.dart';

class SettingScreenBloc extends Bloc<SettingScreenEvent, SettingsScreenState> {
  static const _keyBubbleAlignment = 'bubbleAlignment';
  static const _keyDateTimeModification = 'DateTimeModification';
  static const _keyFontSize = 'fontSize';

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
      yield* _mapChangeChangeFontSizeEventToState(event);
    } else if (event is ResetSettingsEvent) {
      yield* _mapResetSettingsEventToState();
    }
  }

  Stream<SettingsScreenState> _mapInitSettingScreenToState() async* {
    final pref = await SharedPreferences.getInstance();
    final bubbleAlignment = await pref.getBool(_keyBubbleAlignment) ?? false;
    final dateTimeModification =
        await pref.getBool(_keyDateTimeModification) ?? false;
    final fontSize = await pref.getInt(_keyFontSize) ?? 1;
    yield state.copyWith(
      isLeftBubbleAlignment: bubbleAlignment,
      isDateTimeModification: dateTimeModification,
      fontSize: fontSize,
    );
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

  Stream<SettingsScreenState> _mapChangeChangeFontSizeEventToState(
      ChangeFontSizeEvent event) async* {
    final fontSize = event.selectedFontSize;
    final pref = await SharedPreferences.getInstance();
    await pref.setInt(_keyFontSize, fontSize);
    yield state.copyWith(fontSize: fontSize);
  }

  Stream<SettingsScreenState> _mapResetSettingsEventToState() async* {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt(_keyFontSize, 1);
    await pref.setBool(_keyDateTimeModification, false);
    await pref.setBool(_keyBubbleAlignment, false);
    //BlocProvider.of<ThemeBloc>(context).add(ResetThemeEvent());
    yield state.copyWith(
      isDateTimeModification: false,
      isLeftBubbleAlignment: false,
      fontSize: 1,
    );
  }
}
