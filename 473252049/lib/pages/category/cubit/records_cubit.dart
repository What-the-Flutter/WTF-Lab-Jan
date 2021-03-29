import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../extensions/list_get_element.dart';
import '../../../model/record.dart';
import '../../../repositories/records_repository.dart';
import '../../../utils/utils.dart' as utils;

part 'records_state.dart';

class RecordsCubit extends Cubit<RecordsState> {
  final RecordsRepository repository;

  RecordsCubit(this.repository)
      : super(
          RecordsLoadInProcess(null),
        );

  void loadRecords({int categoryId}) async {
    emit(RecordsLoadInProcess(null));
    emit(
      RecordsLoadSuccess(
        await repository.getAllRecords(
          categoryId: categoryId,
        ),
      ),
    );
  }

  void add(Record record, {int categoryId}) async {
    await repository.insert(record);
    emit(
      RecordAddSuccess(
        await repository.getAllRecords(categoryId: categoryId),
        record,
      ),
    );
  }

  void update(Record record, {int categoryId}) async {
    await repository.update(record);
    emit(
      RecordUpdateSuccess(
        await repository.getAllRecords(categoryId: categoryId),
        record,
      ),
    );
  }

  void delete({@required int recordId, int categoryId}) async {
    final deletedRecord = await repository.delete(recordId);
    emit(
      RecordDeleteSuccess(
        await repository.getAllRecords(categoryId: categoryId),
        deletedRecord,
      ),
    );
  }

  void copyToClipboard({@required List<Record> records, int categoryId}) async {
    utils.copyToClipboard(records);
    emit(
      RecordsCopyToClipboardSuccess(state.records, records),
    );
  }

  void select(Record record, {int categoryId}) async {
    await repository.update(
      record.copyWith(isSelected: true),
    );
    state.records.get(record).select();
    record.select();
    emit(
      RecordSelectSuccess(
        state.records,
        record,
      ),
    );
  }

  void unselect(Record record, {int categoryId}) async {
    await repository.update(
      record.copyWith(isSelected: false),
    );
    state.records.get(record).unselect();
    record.unselect();
    emit(
      RecordUnselectSuccess(
        state.records,
        record,
      ),
    );
  }

  void unselectAll({List<Record> records, int categoryId}) async {
    final recordsForUnselect = records ??
        state.records.where((element) => element.isSelected).toList();

    for (var record in recordsForUnselect) {
      await repository.update(
        record.copyWith(isSelected: false),
      );
    }
    emit(
      RecordsUnselectSuccess(
        await repository.getAllRecords(categoryId: categoryId),
        recordsForUnselect,
      ),
    );
  }

  void beginUpdate(Record record, {int categoryId}) {
    emit(
      RecordUpdateInProcess(state.records, record),
    );
  }

  void changeFavorite(List<Record> recordsForChange, {int categoryId}) async {
    for (var record in recordsForChange) {
      record.isFavorite = !record.isFavorite;
      await repository.update(record);
    }
    emit(
      RecordsChangeFavoriteSuccess(
        await repository.getAllRecords(
          categoryId: categoryId,
        ),
        favoirteChangedRecords: recordsForChange,
      ),
    );
  }

  void deleteAll(List<Record> recordsForDelete, {int categoryId}) async {
    for (var record in recordsForDelete) {
      await repository.delete(record.id);
    }
    emit(
      RecordsDeleteSuccess(
        await repository.getAllRecords(
          categoryId: categoryId,
        ),
        deletedRecords: recordsForDelete,
      ),
    );
  }

  void addAll(List<Record> recordsForAdd, {int categoryId}) async {
    for (var record in recordsForAdd) {
      await repository.insert(record);
    }
    emit(
      RecordsAddSuccess(
        await repository.getAllRecords(categoryId: categoryId),
        recordsForAdd,
      ),
    );
  }

  void sendAll(
    List<Record> recordsForSend, {
    @required int categoryToId,
    int categoryId,
  }) async {
    for (var record in recordsForSend) {
      record.categoryId = categoryToId;
      await repository.update(record);
    }
    emit(
      RecordsSendSuccess(
        await repository.getAllRecords(categoryId: categoryId),
        recordsForSend,
      ),
    );
  }

  void showFavorite() {
    emit(
      RecordsShowFavoriteSuccess(
        state.records.where((element) => element.isFavorite).toList(),
      ),
    );
  }
}
