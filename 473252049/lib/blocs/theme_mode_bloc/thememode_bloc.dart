import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'thememode_event.dart';
part 'thememode_state.dart';

class ThememodeBloc extends Bloc<ThememodeEvent, ThememodeState> {
  ThemeMode themeMode;

  ThememodeBloc(this.themeMode) : super(ThememodeInitial());

  @override
  Stream<ThememodeState> mapEventToState(
    ThememodeEvent event,
  ) async* {
    if (event is ThememodeChanged) {
      if (themeMode == ThemeMode.light) {
        themeMode = ThemeMode.dark;
        yield ThememodeSetDarkSuccess();
      } else {
        themeMode = ThemeMode.light;
        yield ThememodeSetLightSuccess();
      }
    }
  }

  @override
  void onTransition(Transition<ThememodeEvent, ThememodeState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}
