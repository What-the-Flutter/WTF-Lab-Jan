import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'date_time_mod_button_state.dart';

class DateTimeModButtonCubit extends Cubit<DateTimeModButtonState> {
  DateTimeModButtonCubit({
    DateTime time,
  }) : super(
          DateTimeModButtonState(
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
