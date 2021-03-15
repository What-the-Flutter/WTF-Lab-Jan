part of 'records_cubit.dart';

abstract class RecordsState extends Equatable {
  final List<Record> records;

  const RecordsState(this.records);

  @override
  List<Object> get props => [records];
}

class RecordsLoadInProcess extends RecordsState {
  RecordsLoadInProcess(List<Record> records) : super(records);
}

class RecordsLoadSuccess extends RecordsState {
  RecordsLoadSuccess(List<Record> records) : super(records);
}

class RecordAddSuccess extends RecordsState {
  final Record record;

  RecordAddSuccess(List<Record> records, this.record) : super(records);

  @override
  List<Object> get props => [records, record];
}

class RecordDeleteSuccess extends RecordsState {
  final Record record;

  RecordDeleteSuccess(List<Record> records, this.record) : super(records);

  @override
  List<Object> get props => [records, record];
}

class RecordUpdateSuccess extends RecordsState {
  final Record record;

  RecordUpdateSuccess(List<Record> records, this.record) : super(records);

  @override
  List<Object> get props => [records, record];
}

class RecordsCopyToClipboardSuccess extends RecordsState {
  final List<Record> copiedRecords;

  RecordsCopyToClipboardSuccess(List<Record> records, this.copiedRecords)
      : super(records);

  @override
  List<Object> get props => [records, copiedRecords];
}

class RecordSelectSuccess extends RecordsState {
  final Record record;

  RecordSelectSuccess(List<Record> records, this.record) : super(records);

  @override
  List<Object> get props => [records, record];
}

class RecordUnselectSuccess extends RecordsState {
  final Record record;

  RecordUnselectSuccess(List<Record> records, this.record) : super(records);

  @override
  List<Object> get props => [records, record];
}

class RecordsUnselectSuccess extends RecordsState {
  final List<Record> unselectedRecords;

  RecordsUnselectSuccess(List<Record> records, this.unselectedRecords)
      : super(records);

  @override
  List<Object> get props => [records, unselectedRecords];
}

class RecordUpdateInProcess extends RecordsState {
  final Record record;

  RecordUpdateInProcess(List<Record> records, this.record) : super(records);

  @override
  List<Object> get props => [records, record];
}

class RecordsChangeFavoriteSuccess extends RecordsState {
  final List<Record> favoirteChangedRecords;

  RecordsChangeFavoriteSuccess(
    List<Record> records, {
    @required this.favoirteChangedRecords,
  }) : super(records);

  @override
  List<Object> get props => [records, favoirteChangedRecords];
}

class RecordsDeleteSuccess extends RecordsState {
  final List<Record> deletedRecords;

  RecordsDeleteSuccess(
    List<Record> records, {
    this.deletedRecords,
  }) : super(records);

  @override
  List<Object> get props => [records, deletedRecords];
}

class RecordsAddSuccess extends RecordsState {
  final List<Record> addedRecords;

  RecordsAddSuccess(List<Record> records, this.addedRecords) : super(records);

  @override
  List<Object> get props => [records, addedRecords];
}

class RecordsSendSuccess extends RecordsState {
  final List<Record> sentRecords;

  RecordsSendSuccess(List<Record> records, this.sentRecords) : super(records);

  @override
  List<Object> get props => [records, sentRecords];
}
