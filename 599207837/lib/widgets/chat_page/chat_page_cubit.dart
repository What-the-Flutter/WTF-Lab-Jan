import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../entity/entities.dart';

import 'chat_page_state.dart';

class ChatPageCubit extends Cubit<ChatPageState> {
  ChatPageCubit() : super(ChatPageState());

  void loadElements(Topic topic) {
    topic.loadElements();
    if (state.searchPage) {
      state.findElements();
    }
    fullRedraw();
  }

  void getElements(Topic topic) {
    state.getElements(topic);
  }

  void onSelect(Message o) {
    if (state.selected.contains(o)) {
      state.selected.remove(o);
    } else {
      state.selected.add(o);
    }
  }

  void deleteSelected() {
    for (var item in state.selected) {
      MessageLoader.remove(item);
    }
    state.selected.clear();
    if (state.searchPage) {
      state.findElements();
    }
    fullRedraw();
  }

  void deleteMessage(Message o) {
    MessageLoader.remove(o);
    if (state.searchPage) {
      state.findElements();
    }
    emit(state.duplicate());
  }

  void clearSelection() {
    state.selected.clear();
  }

  void setSelection(bool val) {
    state.selectionFlag = val;
    fullRedraw();
  }

  void startEditing(int index, int id) {
    state.editingIndex = index;
    state.editingFlag = true;
    fullRedraw();
    changeAddedTypeTo(id);
  }

  void changeAddedType() {
    state.changeAddedType();
    fullRedraw();
  }

  void changeAddedTypeTo(int id) {
    state.changeAddedTypeTo(id);
    fullRedraw();
  }

  void setSelectedTime(TimeOfDay? val) {
    state.selectedTime = val;
    state.selectedDate ??= DateTime.now();
    formRedraw();
  }

  void setSelectedDate(DateTime? val) {
    state.selectedDate = val;
    formRedraw();
  }

  void clearDateTime() {
    state.selectedDate = null;
    state.selectedTime = null;
    formRedraw();
  }

  void onEditEvent(Event o) {
    state.selectedDate = o.scheduledTime;
    if (state.selectedDate != null) {
      state.selectedTime = TimeOfDay.fromDateTime(state.selectedDate!);
    }
    formRedraw();
  }

  void addEvent(String desc, Topic topic) {
    MessageLoader.add(Event(
      scheduledTime: getDateTime(),
      description: desc,
      topic: topic,
    ));
    state.selectedDate = null;
    state.selectedTime = null;
    fullRedraw();
  }

  void add(bool isTask, String desc, Topic topic) {
    if (isTask) {
      MessageLoader.add(
        Task(description: desc, topic: topic),
      );
    } else {
      MessageLoader.add(
        Note(description: desc, topic: topic),
      );
    }
    fullRedraw();
  }

  void finishEditing(bool isTask, String desc) {
    if (isTask) {
      (state.elements[state.editingIndex] as Task).description = desc;
    } else {
      (state.elements[state.editingIndex] as Note).description = desc;
    }
    state.editingFlag = false;
    fullRedraw();
  }

  void finEditEvent(String desc) {
    (state.elements[state.editingIndex] as Event).description = desc;
    (state.elements[state.editingIndex] as Event).scheduledTime = getDateTime();
    state.editingFlag = false;
    state.selectedDate = null;
    state.selectedTime = null;
    fullRedraw();
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

  void buildSearchBar() {
    state.searchPage = true;
    state.searchController = TextEditingController();
    state.searchController!.addListener(() {
      state.findElements();
      fullRedraw();
    });
    appBarRedraw();
  }

  void hideSearchBar() {
    state.searchPage = false;
    state.getElementsAgain();
    state.searchController = null;
    fullRedraw();
  }

  void fullRedraw() {
    state.fullRedraw = true;
    state.appBarRedraw = false;
    state.formRedraw = false;
    emit(state.duplicate());
  }

  void appBarRedraw() {
    state.fullRedraw = false;
    state.appBarRedraw = true;
    state.formRedraw = false;
    emit(state.duplicate());
  }

  void formRedraw() {
    state.fullRedraw = false;
    state.appBarRedraw = false;
    state.formRedraw = true;
    emit(state.duplicate());
  }
}
