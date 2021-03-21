import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../data/theme/theme.dart';

part 'general_options_state.dart';

class GeneralOptionsCubit extends Cubit<GeneralOptionsState> {
  GeneralOptionsCubit(int index)
      : super(GeneralOptionsState(
          themeType: ThemeType.values[index],
          currentTheme: index == 0 ? lightTheme : darkTheme,
          isDateTimeModification: false,
          isLeftBubbleAlign: false,
          isCenterDateBubble: false,
        ));

  void toggleTheme() {
    if (state.themeType == ThemeType.dark) {
      emit(
        state.copyWith(
          themeType: ThemeType.light,
          currentTheme: lightTheme,
        ),
      );
    } else if (state.themeType == ThemeType.light) {
      emit(
        state.copyWith(
          themeType: ThemeType.dark,
          currentTheme: darkTheme,
        ),
      );
    }
  }

  void changeBubbleAlign(bool value) {
    emit(state.copyWith(isLeftBubbleAlign: value));
  }

  void changeDateTimeModification(bool value) {
    emit(state.copyWith(isDateTimeModification: value));
  }

  void changeCenterDateBubble(bool value) {
    emit(state.copyWith(isCenterDateBubble: value));
  }
}
