part of 'date_time_mod_button_cubit.dart';

class DateTimeModButtonState extends Equatable {
  final DateTime fromDate;
  final TimeOfDay fromTime;
  final bool isReset;

  DateTimeModButtonState({
    this.fromDate,
    this.fromTime,
    this.isReset,
  });

  DateTimeModButtonState copyWith({
    final DateTime fromDate,
    final TimeOfDay fromTime,
    final bool isReset,
  }) {
    return DateTimeModButtonState(
      fromDate: fromDate ?? this.fromDate,
      fromTime: fromTime ?? this.fromTime,
      isReset: isReset ?? this.isReset,
    );
  }

  @override
  List<Object> get props => [fromDate, fromTime, isReset];
}
