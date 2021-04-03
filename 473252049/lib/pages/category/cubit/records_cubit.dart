import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../model/category.dart';
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

  Future<List<RecordWithCategory>> getRecordsWithCategory(
      {int categoryId}) async {
    final records = await repository.getAllRecords(categoryId: categoryId);
    final recordsWithCategory = <RecordWithCategory>[];
    for (var record in records) {
      recordsWithCategory.add(
        RecordWithCategory(
          record: record,
          category: await repository.getCategory(
            categoryId: categoryId ?? record.categoryId,
          ),
        ),
      );
    }
    return recordsWithCategory;
  }

  void loadRecords({int categoryId}) async {
    emit(RecordsLoadInProcess(null));
    emit(
      RecordsLoadSuccess(
        await getRecordsWithCategory(categoryId: categoryId),
      ),
    );
  }

  void add(Record record, {int categoryId}) async {
    await repository.insert(record);
    emit(
      RecordAddSuccess(
        await getRecordsWithCategory(categoryId: categoryId),
        record,
      ),
    );
  }

  void update(Record record, {int categoryId}) async {
    await repository.update(record);
    emit(
      RecordUpdateSuccess(
        await getRecordsWithCategory(categoryId: categoryId),
        record,
      ),
    );
  }

  void delete({@required int recordId, int categoryId}) async {
    final deletedRecord = await repository.delete(recordId);
    emit(
      RecordDeleteSuccess(
        await getRecordsWithCategory(categoryId: categoryId),
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
    emit(
      RecordSelectSuccess(
        await getRecordsWithCategory(categoryId: categoryId),
        record..select(),
      ),
    );
  }

  void unselect(Record record, {int categoryId}) async {
    await repository.update(
      record.copyWith(isSelected: false),
    );
    emit(
      RecordUnselectSuccess(
        await getRecordsWithCategory(categoryId: categoryId),
        record..unselect(),
      ),
    );
  }

  void unselectAll({List<Record> records, int categoryId}) async {
    final recordsForUnselect = records ??
        state.records
            .where((element) => element.record.isSelected)
            .map((e) => e.record)
            .toList();

    for (var record in recordsForUnselect) {
      await repository.update(
        record.copyWith(isSelected: false),
      );
      record.unselect();
    }
    emit(
      RecordsUnselectSuccess(
        await getRecordsWithCategory(categoryId: categoryId),
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
        await getRecordsWithCategory(
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
        await getRecordsWithCategory(
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
        await getRecordsWithCategory(categoryId: categoryId),
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
        await getRecordsWithCategory(categoryId: categoryId),
        recordsForSend,
      ),
    );
  }

  void showFavorite() {
    emit(
      RecordsShowFavoriteSuccess(
        state.records.where((element) => element.record.isFavorite).toList(),
      ),
    );
  }
}
