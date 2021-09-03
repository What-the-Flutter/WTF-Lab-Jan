import 'package:equatable/equatable.dart';

import '../../../../../models/category.dart';
import '../../../../../models/tag.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

class FetchDataEvent extends FilterEvent {
  const FetchDataEvent();
}

class SelectTagEvent extends FilterEvent {
  final Tag tag;

  const SelectTagEvent(this.tag);

  @override
  List<Object?> get props => [tag];
}

class SelectCategoryEvent extends FilterEvent {
  final Category category;

  const SelectCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class ResetFilter extends FilterEvent {
  const ResetFilter();
}

class QueryChangedEvent extends FilterEvent {
  final String query;

  const QueryChangedEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearQueryEvent extends FilterEvent {
  const ClearQueryEvent();
}