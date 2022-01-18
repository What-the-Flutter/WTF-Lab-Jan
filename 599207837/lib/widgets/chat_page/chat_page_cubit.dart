import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../database/database.dart' as db;
import '../../entity/entities.dart' as entity;
import 'chat_page_state.dart';

class ChatPageCubit extends Cubit<ChatPageState> {
  ChatPageCubit() : super(ChatPageState.initial());

  void findElements() {
    getElements(state.topic!);
    emit(state.duplicate(
        elements: state.elements!
            .where((element) => element.description
                .toLowerCase()
                .contains(state.searchController!.text.toLowerCase()))
            .toList()));
  }

  void loadElements(entity.Topic topic) {
    topic.loadElements();
    if (state.searchPage) {
      findElements();
    } else {
      emit(state.duplicate());
    }
  }

  void getElements(entity.Topic topic) =>
      emit(state.duplicate(elements: topic.getElements(), topic: topic));

  void onChatExit(entity.Topic topic) {
    db.MessageLoader.clearElements(topic);
    topic.initialLoad = true;
  }

  void onSelect(entity.Message o) {
    if (state.selected!.contains(o)) {
      state.selected!.remove(o);
    } else {
      state.selected!.add(o);
    }
  }

  void moveSelected(entity.Topic topic) {
    for (var item in state.selected!) {
      db.MessageLoader.remove(item);
      item.topic = topic;
      db.MessageLoader.add(item);
    }
    state.selected!.clear();
    if (state.searchPage) {
      findElements();
    } else {
      emit(state.duplicate());
    }
  }

  void deleteSelected() {
    for (var item in state.selected!) {
      db.MessageLoader.remove(item);
    }
    state.selected!.clear();
    if (state.searchPage) {
      findElements();
    } else {
      emit(state.duplicate());
    }
  }

  void deleteMessage(int index) {
    if (state.editingIndex == index) {
      finishEditing(state.elements![index].runtimeType is entity.Event);
    }
    db.MessageLoader.remove(state.elements![index]);
    if (state.searchPage) {
      findElements();
    } else {
      emit(state.duplicate());
    }
  }

  void clearSelection() => state.selected!.clear();

  void setSelection(bool val) => emit(state.duplicate(selectionFlag: val));

  void startEditing(int index, entity.Message o) {
    emit(state.duplicate(editingIndex: index, editingFlag: true));
    state.descriptionController!.text = o.description;
    if (o is entity.Event) {
      _onEditEvent(o);
    }
    changeAddedTypeTo(entity.getTypeId(o));
  }

  void changeAddedType() {
    emit(state.duplicate(
      addedType: (state.addedType + 1) % 3,
      addedIcon: state.addedType == 0
          ? Icons.feed_rounded
          : (state.addedType == 1 ? Icons.event_rounded : Icons.drive_file_rename_outline),
    ));
  }

  void changeAddedTypeTo(int id) {
    if (state.addedType != id) {
      emit(state.duplicate(
        addedType: id,
        addedIcon: state.addedType == 0
            ? Icons.feed_rounded
            : (state.addedType == 1 ? Icons.event_rounded : Icons.drive_file_rename_outline),
      ));
    }
  }

  void setSelectedTime(TimeOfDay? val) =>
      emit(state.duplicate(selectedTime: val, selectedDate: state.selectedDate ?? DateTime.now()));

  void setSelectedDate(DateTime? val) => emit(state.duplicate(selectedDate: val));

  void clearDateTime() => emit(state.duplicate(selectedDate: null, selectedTime: null));

  void _onEditEvent(entity.Event o) {
    if (o.scheduledTime != null) {
      emit(state.duplicate(
        selectedDate: o.scheduledTime,
        selectedTime: TimeOfDay.fromDateTime(o.scheduledTime!),
      ));
    } else {
      emit(state.duplicate(selectedDate: o.scheduledTime));
    }
  }

  void addEvent(entity.Topic topic) {
    db.MessageLoader.add(entity.Event(
      scheduledTime: getDateTime(),
      description: state.descriptionController!.text,
      topic: topic,
    ));
    state.descriptionController!.clear();
    emit(state.duplicate(selectedDate: null, selectedTime: null));
  }

  void add(bool isTask, entity.Topic topic) {
    if (isTask) {
      db.MessageLoader.add(
        entity.Task(description: state.descriptionController!.text, topic: topic),
      );
      state.descriptionController!.clear();
      emit(state.duplicate());
    } else {
      db.MessageLoader.add(
        entity.Note(description: state.descriptionController!.text, topic: topic),
      );
      state.descriptionController!.clear();
      emit(state.duplicate(
        selectedDate: null,
        selectedTime: null,
      ));
    }
  }

  void finishEditing(bool isEvent) {
    state.elements![state.editingIndex].description = state.descriptionController!.text;
    state.descriptionController!.clear();
    if (isEvent) {
      (state.elements![state.editingIndex] as entity.Event).scheduledTime = getDateTime();
      db.MessageLoader.updateMessage(state.elements![state.editingIndex]);
      emit(state.duplicate(
        editingFlag: false,
        selectedDate: null,
        selectedTime: null,
      ));
    } else {
      db.MessageLoader.updateMessage(state.elements![state.editingIndex]);
      emit(state.duplicate(editingFlag: false));
    }
  }

  DateTime? getDateTime() {
    if (state.selectedDate != null && state.selectedTime != null) {
      return DateTime(
        state.selectedDate!.year,
        state.selectedDate!.month,
        state.selectedDate!.day,
        state.selectedTime!.hour,
        state.selectedTime!.minute,
      );
    } else if (state.selectedDate != null) {
      return DateTime(
        state.selectedDate!.year,
        state.selectedDate!.month,
        state.selectedDate!.day,
      );
    }
    return null;
  }

  void buildSearchBar() => emit(state.duplicate(
        searchPage: true,
        searchController: TextEditingController()..addListener(findElements),
      ));

  void hideSearchBar() {
    getElements(state.topic!);
    emit(state.duplicate(searchPage: false, searchController: null));
  }
}
