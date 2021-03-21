part of 'calendar_cubit.dart';

class CalendarState extends Equatable {
  final DateTime fromDate;
  final TimeOfDay fromTime;
  final bool isReset;

  CalendarState({
    this.fromDate,
    this.fromTime,
    this.isReset,
  });

  CalendarState copyWith({
    final DateTime fromDate,
    final TimeOfDay fromTime,
    final bool isReset,
  }) {
    return CalendarState(
      fromDate: fromDate ?? this.fromDate,
      fromTime: fromTime ?? this.fromTime,
      isReset: isReset ?? this.isReset,
    );
  }

  @override
  List<Object> get props => [fromDate, fromTime, isReset];
}
