part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class FavoriteShowed extends CategoryEvent {}

class AllShowed extends CategoryEvent {}

class RecordFavorited extends CategoryEvent {
  final Record record;

  RecordFavorited(this.record);

  @override
  List<Object> get props => [record];
}

class RecordUnfavorited extends CategoryEvent {
  final Record record;

  RecordUnfavorited(this.record);

  @override
  List<Object> get props => [record];
}

class RecordUpdateStarted extends CategoryEvent {
  final Record record;

  RecordUpdateStarted(this.record);

  @override
  List<Object> get props => [record];
}

class RecordsDeleteStarted extends CategoryEvent {
  final List<Record> records;

  RecordsDeleteStarted(this.records);

  @override
  List<Object> get props => [records];
}

class RecordsDeleted extends CategoryEvent {
  final List<Record> records;

  RecordsDeleted(this.records);

  @override
  List<Object> get props => [records];
}

class RecordsDeleteCancelled extends CategoryEvent {}

class RecordsCopied extends CategoryEvent {
  final List<Record> records;

  RecordsCopied(this.records);

  @override
  List<Object> get props => [records];
}

class AllRecordsUnselected extends CategoryEvent {}

class RecordSelected extends CategoryEvent {
  final Record record;

  RecordSelected(this.record);

  @override
  List<Object> get props => [record];
}

class RecordUnselected extends CategoryEvent {
  final Record record;

  RecordUnselected(this.record);

  @override
  List<Object> get props => [record];
}

class RecordAdded extends CategoryEvent {
  final Record record;

  RecordAdded(this.record);

  @override
  List<Object> get props => [record];
}

class RecordUpdated extends CategoryEvent {
  final Record record;
  final String newMessage;

  RecordUpdated(this.record, this.newMessage);

  @override
  List<Object> get props => [record, newMessage];
}

class RecordUpdateCancelled extends CategoryEvent {}

class RecordFavoriteChanged extends CategoryEvent {
  final Record record;

  RecordFavoriteChanged(this.record);

  @override
  List<Object> get props => [record];
}

class RecordSelectChanged extends CategoryEvent {
  final Record record;

  RecordSelectChanged(this.record);

  @override
  List<Object> get props => [record];
}
