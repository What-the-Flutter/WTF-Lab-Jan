import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'thememode_event.dart';
part 'thememode_state.dart';

class ThememodeBloc extends Bloc<ThememodeEvent, ThememodeState> {
  ThememodeBloc(ThemeMode themeMode) : super(ThememodeInitial(themeMode));

  @override
  Stream<ThememodeState> mapEventToState(
    ThememodeEvent event,
  ) async* {
    if (event is ThememodeChanged) {
      if (state.themeMode == ThemeMode.light) {
        yield ThememodeSetDarkSuccess(ThemeMode.dark);
      } else {
        yield ThememodeSetLightSuccess(ThemeMode.light);
      }
    }
  }

  @override
  void onTransition(Transition<ThememodeEvent, ThememodeState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}
