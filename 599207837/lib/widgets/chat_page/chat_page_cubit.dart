import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../entity/entities.dart';

import 'chat_page_state.dart';

class ChatPageCubit extends Cubit<ChatPageState> {
  ChatPageCubit() : super(ChatPageState()..descriptionController = TextEditingController());

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

  void moveSelected(Topic topic) {
    for (var item in state.selected) {
      MessageLoader.remove(item);
      item.topic = topic;
      MessageLoader.add(item);
    }
    state.selected.clear();
    if (state.searchPage) {
      state.findElements();
    }
    fullRedraw();
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

  void deleteMessage(int index) {
    if (state.editingIndex == index) {
      finishEditing(state.elements[index].runtimeType is Event);
    }
    MessageLoader.remove(state.elements[index]);
    if (state.searchPage) {
      state.findElements();
    }
    fullRedraw();
  }

  void clearSelection() {
    state.selected.clear();
  }

  void setSelection(bool val) {
    state.selectionFlag = val;
    fullRedraw();
  }

  void startEditing(int index, Message o) {
    state.editingIndex = index;
    state.editingFlag = true;
    state.descriptionController!.text = o.description;
    if (o is Event) {
      _onEditEvent(o);
    }
    fullRedraw();
    changeAddedTypeTo(getTypeId(o));
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

  void _onEditEvent(Event o) {
    state.selectedDate = o.scheduledTime;
    if (state.selectedDate != null) {
      state.selectedTime = TimeOfDay.fromDateTime(state.selectedDate!);
    }
  }

  void addEvent(Topic topic) {
    MessageLoader.add(Event(
      scheduledTime: getDateTime(),
      description: state.descriptionController!.text,
      topic: topic,
    ));
    state.selectedDate = null;
    state.selectedTime = null;
    state.descriptionController!.clear();
    fullRedraw();
  }

  void add(bool isTask, Topic topic) {
    if (isTask) {
      MessageLoader.add(
        Task(description: state.descriptionController!.text, topic: topic),
      );
    } else {
      MessageLoader.add(
        Note(description: state.descriptionController!.text, topic: topic),
      );
    }
    fullRedraw();
  }

  void finishEditing(bool isEvent) {
    state.elements[state.editingIndex].description = state.descriptionController!.text;
    state.editingFlag = false;
    if (isEvent) {
      (state.elements[state.editingIndex] as Event).scheduledTime = getDateTime();
      state.selectedDate = null;
      state.selectedTime = null;
    }
    state.descriptionController!.clear();
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
