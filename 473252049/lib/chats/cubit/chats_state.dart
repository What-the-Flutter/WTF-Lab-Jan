part of 'chats_cubit.dart';

abstract class ChatsState extends Equatable {
  final List<Category> categories;

  const ChatsState(this.categories);

  @override
  List<Object> get props => [categories];
}

class ChatsInitial extends ChatsState {
  ChatsInitial(List<Category> categories) : super(categories);
}

class CategoryAddSuccess extends ChatsState {
  final Category category;

  CategoryAddSuccess(List<Category> categories, this.category)
      : super(categories);

  @override
  List<Object> get props => [categories, category];
}

class CategoryDeleteSuccess extends ChatsState {
  final Category category;

  CategoryDeleteSuccess(List<Category> categories, this.category)
      : super(categories);

  @override
  List<Object> get props => [categories, category];
}

class CategoryPinSuccess extends ChatsState {
  final Category category;

  CategoryPinSuccess(List<Category> categories, this.category)
      : super(categories);

  @override
  List<Object> get props => [categories, category];
}

class CategoryUnpinSuccess extends ChatsState {
  final Category category;

  CategoryUnpinSuccess(List<Category> categories, this.category)
      : super(categories);

  @override
  List<Object> get props => [categories, category];
}

class CategoryUpdateSuccess extends ChatsState {
  final Category category;

  CategoryUpdateSuccess(List<Category> categories, this.category)
      : super(categories);

  @override
  List<Object> get props => [categories, category];
}

class RecordAddSuccess extends ChatsState {
  final Category category;
  final Record record;

  RecordAddSuccess(List<Category> categories, this.category, this.record)
      : super(categories);

  @override
  List<Object> get props => [categories, category, record];
}

class RecordsDeleteSuccess extends ChatsState {
  final Category category;
  final List<Record> records;

  RecordsDeleteSuccess(List<Category> categories, this.category, this.records)
      : super(categories);

  @override
  List<Object> get props => [categories, category, records];
}

class RecordSelectSuccess extends ChatsState {
  final Category category;
  final Record record;

  RecordSelectSuccess(List<Category> categories, this.category, this.record)
      : super(categories);

  @override
  List<Object> get props => [categories, category, record];
}

class RecordUnselectSuccess extends ChatsState {
  final Category category;
  final Record record;

  RecordUnselectSuccess(List<Category> categories, this.category, this.record)
      : super(categories);

  @override
  List<Object> get props => [categories, category, record];
}

class RecordsUnselectSuccess extends ChatsState {
  final Category category;
  final List<Record> records;

  RecordsUnselectSuccess(List<Category> categories, this.category, this.records)
      : super(categories);

  @override
  List<Object> get props => [categories, category, records];
}

class RecordUpdateInProcess extends ChatsState {
  final Category category;
  final Record record;

  RecordUpdateInProcess(List<Category> categories, this.category, this.record)
      : super(categories);

  @override
  List<Object> get props => [categories, category, record];
}

class RecordUpdateSuccess extends ChatsState {
  final Category category;
  final Record record;

  RecordUpdateSuccess(List<Category> categories, this.category, this.record)
      : super(categories);

  @override
  List<Object> get props => [categories, category, record];
}

class RecordsChangeFavoriteSuccess extends ChatsState {
  final Category category;
  final List<Record> records;

  RecordsChangeFavoriteSuccess(
      List<Category> categories, this.category, this.records)
      : super(categories);

  @override
  List<Object> get props => [categories, category, records];
}
