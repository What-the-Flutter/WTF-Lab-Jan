import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../repositories/categories_repository.dart';
import '../../../../../repositories/records_repository.dart';
import '../categories_statistics_data.dart';

part 'categoriesstatistics_state.dart';

class CategoriesstatisticsCubit extends Cubit<CategoriesstatisticsState> {
  final RecordsRepository recordsRepository;
  final CategoriesRepository categoriesRepository;

  CategoriesstatisticsCubit({this.recordsRepository, this.categoriesRepository})
      : super(CategoriesstatisticsState());

  void loadChart() async {
    final dataList = <CategoriesStatisticsData>[];
    final categoriesList = await categoriesRepository.getAll();
    int recordsCount;
    for (var category in categoriesList) {
      recordsCount = await recordsRepository.getRecordsCount(
        categoryId: category.id,
      );
      if (recordsCount > 0) {
        dataList.add(
          CategoriesStatisticsData(
            categoryName: category.name,
            recordsCount: recordsCount,
          ),
        );
      }
    }
    emit(CategoriesstatisticsState(dataList: dataList));
  }
}
