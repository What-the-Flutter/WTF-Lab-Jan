import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../entity/entities.dart';

import 'chat_page_state.dart';

class ChatPageCubit extends Cubit<ChatPageState> {
  ChatPageCubit() : super(ChatPageState());

  void loadElements(Topic topic) {
    topic.loadElements();
    needToRedraw();
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
    state.needToRedraw = false;
    emit(state.duplicate());
  }

  void deleteSelected() {
    for (var item in state.selected) {
      MessageLoader.remove(item);
    }
    state.selected.clear();
    needToRedraw();
  }

  void deleteMessage(Message o) {
    MessageLoader.remove(o);
    emit(state.duplicate());
  }

  void clearSelection() {
    state.selected.clear();
  }

  void setSelection(bool val) {
    state.selectionFlag = val;
    needToRedraw();
  }

  void startEditing(int index, int id) {
    state.editingIndex = index;
    state.editingFlag = true;
    needToRedraw();
    changeAddedTypeTo(id);
  }

  void changeAddedType() {
    state.changeAddedType();
    needToRedraw();
  }

  void changeAddedTypeTo(int id) {
    state.changeAddedTypeTo(id);
    needToRedraw();
  }

  void setSelectedTime(TimeOfDay? val) {
    state.selectedTime = val;
    state.selectedDate ??= DateTime.now();
    state.dateTimeChanged = true;
    state.needToRedraw = false;
    emit(state.duplicate());
  }

  void setSelectedDate(DateTime? val) {
    state.selectedDate = val;
    state.dateTimeChanged = true;
    state.needToRedraw = false;
    emit(state.duplicate());
  }

  void clearDateTime() {
    state.selectedDate = null;
    state.selectedTime = null;
    state.dateTimeChanged = true;
    state.needToRedraw = false;
    emit(state.duplicate());
  }

  void onEditEvent(Event o) {
    state.selectedDate = o.scheduledTime;
    if (state.selectedDate != null) {
      state.selectedTime = TimeOfDay.fromDateTime(state.selectedDate!);
    }
    state.dateTimeChanged = true;
    state.needToRedraw = false;
    emit(state.duplicate());
  }

  void addEvent(String desc, Topic topic) {
    MessageLoader.add(Event(
      scheduledTime: getDateTime(),
      description: desc,
      topic: topic,
    ));
    state.selectedDate = null;
    state.selectedTime = null;
    needToRedraw();
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
    needToRedraw();
  }

  void finishEditing(bool isTask, String desc) {
    if (isTask) {
      (state.elements[state.editingIndex] as Task).description = desc;
    } else {
      (state.elements[state.editingIndex] as Note).description = desc;
    }
    state.editingFlag = false;
    needToRedraw();
  }

  void finEditEvent(String desc) {
    (state.elements[state.editingIndex] as Event).description = desc;
    (state.elements[state.editingIndex] as Event).scheduledTime = getDateTime();
    state.editingFlag = false;
    state.selectedDate = null;
    state.selectedTime = null;
    needToRedraw();
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

  void needToRedraw() {
    state.needToRedraw = true;
    emit(state.duplicate());
  }
}
