part of 'statistic_cubit.dart';

class StatisticState extends Equatable {
  final TypeStatistic typeStatistic;
  final TypeTimeDiagram selectedTime;
  final List<ModelMessage> list;

  StatisticState({
    this.typeStatistic,
    this.selectedTime,
    this.list,
  });

  StatisticState copyWith({
    final TypeStatistic typeStatistic,
    final TypeTimeDiagram selectedTime,
    final List<ModelMessage> list,
  }) {
    return StatisticState(
      typeStatistic: typeStatistic ?? this.typeStatistic,
      selectedTime: selectedTime ?? this.selectedTime,
      list: list ?? this.list,
    );
  }

  @override
  List<Object> get props => [typeStatistic, selectedTime, list];
}
