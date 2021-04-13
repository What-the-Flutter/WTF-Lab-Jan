import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../repositories/records_repository.dart';
import '../time_statistics_data.dart';

part 'timestatistics_state.dart';

class TimestatisticsCubit extends Cubit<TimestatisticsState> {
  final RecordsRepository recordsRepository;
  final defaultDaysCount = 7;

  TimestatisticsCubit({this.recordsRepository}) : super(TimestatisticsState());

  void loadChartPerDays({int daysCount}) async {
    final dataList = <TimeStatisticsData>[];
    final allRecords = await recordsRepository.getAllRecords();
    final now = DateTime.now();
    DateTime statisticsDateTime;
    for (var i = 0; i < (daysCount ?? defaultDaysCount); ++i) {
      statisticsDateTime = now.subtract(Duration(days: i));
      dataList.add(
        TimeStatisticsData(
          dateTime: statisticsDateTime,
          recordsCount: allRecords.where(
            (element) {
              return element.createDateTime.year == statisticsDateTime.year &&
                  element.createDateTime.month == statisticsDateTime.month &&
                  element.createDateTime.day == statisticsDateTime.day;
            },
          ).length,
        ),
      );
    }
    emit(TimestatisticsState(dataList: dataList));
  }

  void loadChart() {
    loadWeekChart();
  }

  void loadWeekChart() {
    loadChartPerDays(daysCount: 7);
  }

  void loadMonthChart() {
    loadChartPerDays(daysCount: 30);
  }
}
