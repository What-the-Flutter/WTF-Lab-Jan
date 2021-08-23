import 'package:equatable/equatable.dart';

import '../../../../models/category.dart';

class CategoryCount extends Equatable {
  final Category category;
  final int count;

  CategoryCount(this.category, this.count);

  @override
  List<Object?> get props => [category, count];
}
