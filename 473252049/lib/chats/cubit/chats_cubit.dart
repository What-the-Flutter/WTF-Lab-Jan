import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../extensions/list_get_element.dart';
import '../../model/category.dart';
import '../../model/record.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit(List categories) : super(ChatsInitial(categories..sort()));

  void addCategory(Category category) {
    state.categories.add(category);
    emit(CategoryAddSuccess(state.categories, category));
  }

  void deleteCategory(Category category) {
    state.categories.remove(category);
    emit(CategoryDeleteSuccess(state.categories, category));
  }

  void pinCategory(Category category) {
    state.categories.get(category).pin();
    emit(CategoryPinSuccess(state.categories..sort(), category));
  }

  void unpinCategory(Category category) {
    state.categories.get(category).unpin();
    emit(CategoryUnpinSuccess(state.categories..sort(), category));
  }

  void updateCategory(Category category,
      {@required String newName, IconData newIconData}) {
    state.categories.get(category)
      ..name = newName
      ..icon = newIconData;
    emit(CategoryUpdateSuccess(state.categories..sort(), category));
  }

  void addRecord(Category category, Record record) {
    state.categories.get(category).add(record);
    emit(RecordAddSuccess(state.categories..sort(), category, record));
  }

  void deleteRecords(Category category, List<Record> records) {
    for (var record in records) {
      state.categories.get(category).delete(record);
    }
    emit(RecordsDeleteSuccess(state.categories, category, records));
  }

  void selectRecord(Category category, Record record) {
    state.categories.get(category).select(record);
    emit(RecordSelectSuccess(state.categories, category, record));
  }

  void unselectRecord(Category category, Record record) {
    state.categories.get(category).unselect(record);
    emit(RecordUnselectSuccess(state.categories, category, record));
  }

  void unselectAllRecords(Category category) {
    final selectedRecords = category.selectedRecords;
    for (var record in selectedRecords) {
      state.categories.get(category).unselect(record);
    }
    emit(RecordsUnselectSuccess(state.categories, category, selectedRecords));
  }

  void beginUpdateRecord(Category category, Record record) {
    emit(RecordUpdateInProcess(state.categories, category, record));
  }

  void updateRecord(Category category, Record record,
      {String newMessage, File newImage}) {
    state.categories
        .get(category)
        .update(record, newMessage: newMessage, newImage: newImage);
    emit(RecordUpdateSuccess(state.categories, category, record));
  }

  void changeFavoriteRecords(Category category, List<Record> records) {
    for (var record in records) {
      state.categories.get(category).changeFavorite(record);
    }
    emit(RecordsChangeFavoriteSuccess(state.categories, category, records));
  }

  void sendRecord(
      {@required Category categoryFrom,
      @required Category categoryTo,
      @required List<Record> records}) {
    for (var record in records) {
      state.categories.get(categoryFrom).delete(record);
      state.categories.get(categoryTo).add(record);
    }
    emit(RecordsSendSuccess(state.categories,
        categoryFrom: categoryFrom, categoryTo: categoryTo, records: records));
  }
}
