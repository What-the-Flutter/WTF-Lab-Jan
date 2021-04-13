part of 'categoriesstatistics_cubit.dart';

class CategoriesstatisticsState extends Equatable {
  final List<CategoriesStatisticsData> dataList;

  const CategoriesstatisticsState({this.dataList});

  @override
  List<Object> get props => [dataList];
}
