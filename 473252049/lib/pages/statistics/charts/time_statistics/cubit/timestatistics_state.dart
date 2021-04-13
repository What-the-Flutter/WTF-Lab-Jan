part of 'timestatistics_cubit.dart';

class TimestatisticsState extends Equatable {
  final List<TimeStatisticsData> dataList;

  const TimestatisticsState({this.dataList});

  @override
  List<Object> get props => [dataList];
}
