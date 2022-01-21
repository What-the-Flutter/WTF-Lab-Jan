import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../database/database.dart';
import '../../entity/entities.dart';
import 'chat_page_state.dart';

class ChatPageCubit extends Cubit<ChatPageState> {
  ChatPageCubit() : super(ChatPageState.initial());

  void findElements() {
    emit(state.duplicate(
        searchMessages: state.elements!
            .where((element) => element.description
                .toLowerCase()
                .contains(state.searchController!.text.toLowerCase()))
            .toList()));
  }

  void getElements(Topic topic) async =>
      emit(state.duplicate(elements: await topic.getElements(), topic: topic));

  void onSelect(Message o) {
    if (state.selected!.contains(o)) {
      state.selected!.remove(o);
    } else {
      state.selected!.add(o);
    }
  }

  void moveSelected(Topic topic) {
    for (var item in state.selected!) {
      MessageRepository.remove(item);
      item.topic = topic;
      MessageRepository.add(item);
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
      MessageRepository.remove(item);
      state.elements!.remove(item);
    }
    state.selected!.clear();
    if (state.searchPage) {
      findElements();
    } else {
      emit(state.duplicate());
    }
  }

  void deleteMessage(int index) {
    if (state.editingFlag && state.editingIndex == index) {
      finishEditing(state.messages[index].runtimeType is Event);
    }
    final deleted = state.messages[index];
    MessageRepository.remove(deleted);
    state.elements!.remove(deleted);
    if (state.searchPage) {
      findElements();
    } else {
      emit(state.duplicate());
    }
  }

  void clearSelection() => state.selected!.clear();

  void setSelection(bool val) => emit(state.duplicate(selectionFlag: val));

  void startEditing(int index, Message o) {
    emit(state.duplicate(editingIndex: index, editingFlag: true));
    state.descriptionController!.text = o.description;
    if (o is Event) {
      _onEditEvent(o);
    }
    changeAddedTypeTo(getTypeId(o));
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

  void _onEditEvent(Event o) {
    if (o.scheduledTime != null) {
      emit(state.duplicate(
        selectedDate: o.scheduledTime,
        selectedTime: TimeOfDay.fromDateTime(o.scheduledTime!),
      ));
    } else {
      emit(state.duplicate(selectedDate: o.scheduledTime));
    }
  }

  void addEvent(Topic topic) {
    final added = Event(
      scheduledTime: _getDateTime(),
      description: state.descriptionController!.text,
      topic: topic,
    );
    MessageRepository.add(added);
    state.elements!.insert(0, added);
    state.descriptionController!.clear();
    emit(state.duplicate(selectedDate: null, selectedTime: null));
  }

  void add(bool isTask, Topic topic) {
    if (isTask) {
      final added = Task(description: state.descriptionController!.text, topic: topic);
      MessageRepository.add(added);
      state.elements!.insert(0, added);
      state.descriptionController!.clear();
      emit(state.duplicate());
    } else {
      final added = Note(description: state.descriptionController!.text, topic: topic);
      MessageRepository.add(
        added,
      );
      state.elements!.insert(0, added);
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
      (state.elements![state.editingIndex] as Event).scheduledTime = _getDateTime();
      MessageRepository.updateMessage(state.elements![state.editingIndex]);
      emit(state.duplicate(
        editingFlag: false,
        selectedDate: null,
        selectedTime: null,
      ));
    } else {
      MessageRepository.updateMessage(state.elements![state.editingIndex]);
      emit(state.duplicate(editingFlag: false));
    }
  }

  DateTime? _getDateTime() {
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
    emit(state.duplicate(
      searchPage: false,
      searchController: null,
      searchMessages: null,
    ));
  }
}
