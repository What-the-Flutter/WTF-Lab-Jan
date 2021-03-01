part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  final Category category;

  const CategoryState(this.category);

  @override
  List<Object> get props => [category];
}

class CategoryInitial extends CategoryState {
  CategoryInitial(Category category) : super(category);
}

class FavoriteShowSuccess extends CategoryState {
  FavoriteShowSuccess(Category category) : super(category);
}

class AllShowedSuccess extends CategoryState {
  AllShowedSuccess(Category category) : super(category);
}

class RecordFavoriteSuccess extends CategoryState {
  final Record record;

  RecordFavoriteSuccess(Category category, this.record) : super(category);

  @override
  List<Object> get props => [record, category];
}

class RecordUnfavoriteSuccess extends CategoryState {
  final Record record;

  RecordUnfavoriteSuccess(Category category, this.record) : super(category);

  @override
  List<Object> get props => [record, category];
}

class RecordUpdateInProcess extends CategoryState {
  final Record record;

  RecordUpdateInProcess(Category category, this.record) : super(category);

  @override
  List<Object> get props => [record, category];
}

class RecordsDeleteInProcess extends CategoryState {
  final List<Record> records;

  RecordsDeleteInProcess(Category category, this.records) : super(category);

  @override
  List<Object> get props => [records, category];
}

class RecordDeleteSuccess extends CategoryState {
  RecordDeleteSuccess(Category category) : super(category);
}

class RecordDeleteCancelSuccess extends CategoryState {
  RecordDeleteCancelSuccess(Category category) : super(category);
}

class RecordsCopySuccess extends CategoryState {
  final List<Record> records;

  RecordsCopySuccess(Category category, this.records) : super(category);

  @override
  List<Object> get props => [records, category];
}

class RecordSelectSuccess extends CategoryState {
  final Record record;

  RecordSelectSuccess(Category category, this.record) : super(category);

  @override
  List<Object> get props => [record, category];
}

class RecordUnselectSuccess extends CategoryState {
  final Record record;

  RecordUnselectSuccess(Category category, this.record) : super(category);

  @override
  List<Object> get props => [record, category];
}

class RecordAddSuccess extends CategoryState {
  final Record record;

  RecordAddSuccess(Category category, this.record) : super(category);

  @override
  List<Object> get props => [record, category];
}

class RecordUpdateCancelSuccess extends CategoryState {
  RecordUpdateCancelSuccess(Category category) : super(category);
}

class RecordUpdateSuccess extends CategoryState {
  final Record record;

  RecordUpdateSuccess(Category category, this.record) : super(category);

  @override
  List<Object> get props => [category, record];
}
