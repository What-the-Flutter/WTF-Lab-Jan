import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit({
    DateTime time,
  }) : super(
          CalendarState(
            fromDate: time,
            fromTime: TimeOfDay.fromDateTime(time),
            isReset: false,
          ),
        );

  void updateDateAndTime({
    DateTime date,
    TimeOfDay time,
  }) {
    if (date != state.fromDate || time != state.fromTime) {
      emit(state.copyWith(
        fromDate: date,
        fromTime: time,
        isReset: true,
      ));
    }
  }

  void reset() {
    final date = DateTime.now();
    emit(state.copyWith(
      fromDate: date,
      fromTime: TimeOfDay.fromDateTime(date),
      isReset: false,
    ));
  }
}
