import 'package:bloc/bloc.dart';
import 'package:chat_journal/utils/utils.dart';
import 'package:equatable/equatable.dart';

import '../../model/category.dart';
import '../../model/record.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit(Category category) : super(CategoryInitial(category));

  void addRecord(Record record) {
    state.category.add(record);
    emit(RecordAddSuccess(state.category, record));
  }

  void deleteRecord(Record record) {
    state.category.delete(record);
    emit(RecordDeleteSuccess(state.category, record));
  }

  void updateRecord(Record record, String newMessage) {
    state.category.update(record, newMessage: newMessage);
    emit(RecordUpdateSuccess(state.category, record));
  }

  void selectRecord(Record record) {
    state.category.select(record);
    emit(RecordSelectSuccess(state.category, record));
  }

  void unselectRecord(Record record) {
    state.category.unselect(record);
    emit(RecordUnselectSuccess(state.category, record));
  }

  void unselectRecords(List<Record> records) {
    for (var record in records) {
      state.category.unselect(record);
    }
    emit(RecordsUnselectSuccess(state.category, records));
  }

  void unselectAllRecords() {
    final selectedRecords = state.category.selectedRecords;
    for (var record in selectedRecords) {
      state.category.unselect(record);
    }
    emit(RecordsUnselectSuccess(state.category, selectedRecords));
  }

  void favoriteRecords(List<Record> records) {
    for (var record in records) {
      state.category.favorite(record);
    }
    emit(RecordsFavoriteSuccess(state.category, records));
  }

  void cancelUpdateRecord() {
    state.category.unselectAll();
    emit(RecordUpdateCancel(state.category));
  }

  void beginUpdateRecord(Record record) {
    emit(RecordUpdateInProcess(state.category, record));
  }

  void changeFavoriteRecords(List<Record> records) {
    for (var record in records) {
      if (record.isFavorite) {
        state.category.unfavorite(record);
      } else {
        state.category.favorite(record);
      }
    }
    emit(RecordsChangeFavoriteSuccess(state.category, records));
  }

  void deleteRecords(List<Record> records) {
    for (var record in records) {
      state.category.delete(record);
    }
    emit(RecordsDeleteSuccess(state.category, records));
  }

  void copyRecords(List<Record> records) {
    copyToClipboard(records);
    emit(RecordsCopySuccess(state.category, records));
  }
}
