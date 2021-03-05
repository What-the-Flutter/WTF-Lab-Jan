part of 'category_cubit.dart';

abstract class CategoryState extends Equatable {
  final Category category;

  const CategoryState(this.category);

  @override
  List<Object> get props => [category];
}

class CategoryInitial extends CategoryState {
  CategoryInitial(Category category) : super(category);
}

class RecordAddSuccess extends CategoryState {
  final Record record;

  RecordAddSuccess(Category category, this.record) : super(category);

  @override
  List<Object> get props => [category, record];
}

class RecordDeleteSuccess extends CategoryState {
  final Record record;

  RecordDeleteSuccess(Category category, this.record) : super(category);
}

class RecordsDeleteSuccess extends CategoryState {
  final List<Record> records;
  RecordsDeleteSuccess(Category category, this.records) : super(category);
}

class RecordUpdateSuccess extends CategoryState {
  final Record record;

  RecordUpdateSuccess(Category category, this.record) : super(category);
}

class RecordUpdateInProcess extends CategoryState {
  final Record record;

  RecordUpdateInProcess(Category category, this.record) : super(category);
}

class RecordUpdateCancel extends CategoryState {
  RecordUpdateCancel(Category category) : super(category);
}

class RecordSelectSuccess extends CategoryState {
  final Record record;

  RecordSelectSuccess(Category category, this.record) : super(category);

  @override
  List<Object> get props => [category, record];
}

class RecordUnselectSuccess extends CategoryState {
  final Record record;

  RecordUnselectSuccess(Category category, this.record) : super(category);

  @override
  List<Object> get props => [category, record];
}

class RecordsUnselectSuccess extends CategoryState {
  final List<Record> records;

  RecordsUnselectSuccess(Category category, this.records) : super(category);
}

class RecordsFavoriteSuccess extends CategoryState {
  final List<Record> records;

  RecordsFavoriteSuccess(Category category, this.records) : super(category);
}

class RecordsChangeFavoriteSuccess extends CategoryState {
  final List<Record> records;

  RecordsChangeFavoriteSuccess(Category category, this.records)
      : super(category);
}

class RecordsCopySuccess extends CategoryState {
  final List<Record> records;

  RecordsCopySuccess(Category category, this.records) : super(category);
}
