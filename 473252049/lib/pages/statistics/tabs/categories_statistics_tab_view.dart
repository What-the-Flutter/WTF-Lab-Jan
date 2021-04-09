import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/local_database/local_database_categories_repository.dart';
import '../../../repositories/local_database/local_database_records_repository.dart';
import '../charts/categories_statistics/categories_statistics_chart.dart';
import '../charts/categories_statistics/cubit/categoriesstatistics_cubit.dart';

class CategoriesStatisticsTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return CategoriesstatisticsCubit(
          recordsRepository: LocalDatabaseRecordsRepository(),
          categoriesRepository: LocalDatabaseCategoriesRepository(),
        )..loadChart();
      },
      child: Builder(
        builder: (context) {
          return BlocBuilder<CategoriesstatisticsCubit,
              CategoriesstatisticsState>(
            builder: (context, state) {
              if (state.dataList == null) {
                return CircularProgressIndicator();
              }
              if (state.dataList.isEmpty) {
                return Center(
                  child: Text('No records yet'),
                );
              }
              return CategoriesStatisticsChart(
                dataList: state.dataList,
              );
            },
          );
        },
      ),
    );
  }
}
