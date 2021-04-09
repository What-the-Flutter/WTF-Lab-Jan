import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/local_database/local_database_records_repository.dart';
import '../charts/time_statistics/cubit/timestatistics_cubit.dart';
import '../charts/time_statistics/time_statistics_chart.dart';
import '../widgets/select_period_dropdown_button.dart';

class TimeStatisticsTabView extends StatelessWidget {
  const TimeStatisticsTabView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return TimestatisticsCubit(
          recordsRepository: LocalDatabaseRecordsRepository(),
        )..loadChart();
      },
      child: Builder(
        builder: (context) {
          return BlocBuilder<TimestatisticsCubit, TimestatisticsState>(
            builder: (context, state) {
              if (state.dataList == null) {
                return CircularProgressIndicator();
              }
              if (state.dataList.isEmpty) {
                return Center(
                  child: Text('No records in selected period'),
                );
              }
              return SafeArea(
                child: Column(
                  children: [
                    SelectPeriodDropdownButton(),
                    TimeStatisticsChart(
                      dataList: state.dataList,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
