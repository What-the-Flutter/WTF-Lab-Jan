part of 'records_cubit.dart';

class RecordWithCategory {
  final Record record;
  final Category category;

  RecordWithCategory({
    @required this.record,
    @required this.category,
  });
}

abstract class RecordsState extends Equatable {
  final List<RecordWithCategory> records;

  const RecordsState(this.records);

  @override
  List<Object> get props => [records];
}

class RecordsLoadInProcess extends RecordsState {
  RecordsLoadInProcess(List<RecordWithCategory> records) : super(records);
}

class RecordsLoadSuccess extends RecordsState {
  RecordsLoadSuccess(List<RecordWithCategory> records) : super(records);
}

class RecordAddSuccess extends RecordsState {
  final Record record;

  RecordAddSuccess(List<RecordWithCategory> records, this.record)
      : super(records);

  @override
  List<Object> get props => [records, record];
}

class RecordDeleteSuccess extends RecordsState {
  final Record record;

  RecordDeleteSuccess(List<RecordWithCategory> records, this.record)
      : super(records);

  @override
  List<Object> get props => [records, record];
}

class RecordUpdateSuccess extends RecordsState {
  final Record record;

  RecordUpdateSuccess(List<RecordWithCategory> records, this.record)
      : super(records);

  @override
  List<Object> get props => [records, record];
}

class RecordsCopyToClipboardSuccess extends RecordsState {
  final List<Record> copiedRecords;

  RecordsCopyToClipboardSuccess(
      List<RecordWithCategory> records, this.copiedRecords)
      : super(records);

  @override
  List<Object> get props => [records, copiedRecords];
}

class RecordSelectSuccess extends RecordsState {
  final Record record;

  RecordSelectSuccess(List<RecordWithCategory> records, this.record)
      : super(records);

  @override
  List<Object> get props => [records, record];
}

class RecordUnselectSuccess extends RecordsState {
  final Record record;

  RecordUnselectSuccess(List<RecordWithCategory> records, this.record)
      : super(records);

  @override
  List<Object> get props => [records, record];
}

class RecordsUnselectSuccess extends RecordsState {
  final List<Record> unselectedRecords;

  RecordsUnselectSuccess(
      List<RecordWithCategory> records, this.unselectedRecords)
      : super(records);

  @override
  List<Object> get props => [records, unselectedRecords];
}

class RecordUpdateInProcess extends RecordsState {
  final Record record;

  RecordUpdateInProcess(List<RecordWithCategory> records, this.record)
      : super(records);

  @override
  List<Object> get props => [records, record];
}

class RecordsChangeFavoriteSuccess extends RecordsState {
  final List<Record> favoirteChangedRecords;

  RecordsChangeFavoriteSuccess(
    List<RecordWithCategory> records, {
    @required this.favoirteChangedRecords,
  }) : super(records);

  @override
  List<Object> get props => [records, favoirteChangedRecords];
}

class RecordsDeleteSuccess extends RecordsState {
  final List<Record> deletedRecords;

  RecordsDeleteSuccess(
    List<RecordWithCategory> records, {
    this.deletedRecords,
  }) : super(records);

  @override
  List<Object> get props => [records, deletedRecords];
}

class RecordsAddSuccess extends RecordsState {
  final List<Record> addedRecords;

  RecordsAddSuccess(List<RecordWithCategory> records, this.addedRecords)
      : super(records);

  @override
  List<Object> get props => [records, addedRecords];
}

class RecordsSendSuccess extends RecordsState {
  final List<Record> sentRecords;

  RecordsSendSuccess(List<RecordWithCategory> records, this.sentRecords)
      : super(records);

  @override
  List<Object> get props => [records, sentRecords];
}

class RecordsShowFavoriteSuccess extends RecordsState {
  RecordsShowFavoriteSuccess(List<RecordWithCategory> records) : super(records);
}
