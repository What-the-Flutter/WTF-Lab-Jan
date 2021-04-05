import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../data/database_provider.dart';
import '../event.dart';
import '../note.dart';
import 'states_event_page.dart';

class CubitEventPage extends Cubit<StatesEventPage> {
  CubitEventPage(state) : super(state);
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void initEventList() async {
    state.eventList = await _databaseProvider.dbEventList(state.note.id);
    emit(state.copyWith(eventList: state.eventList));
  }

  void setTextSearch(bool isSearch) => emit(state.copyWith(isSearch: isSearch));

  void setEventsList(List<Event> eventList) =>
      emit(state.copyWith(eventList: eventList));

  void setTextEditing(bool isEditing) =>
      emit(state.copyWith(isEditing: isEditing));

  void setIndexOfSelectedElement(Event selectedElement) =>
      emit(state.copyWith(selectedElement: selectedElement));

  void setIndexOfSelectedCircleAvatar(int indexOfSelectedCircleAvatar) => emit(
      state.copyWith(indexOfSelectedCircleAvatar: indexOfSelectedCircleAvatar));

  void editText(Event event, TextEditingController textController,
      int indexOfSelectedCircleAvatar) {
    if (textController.text.isNotEmpty) {
      event.text = textController.text;
      event.indexOfCircleAvatar = indexOfSelectedCircleAvatar;
      _databaseProvider.updateEvent(event);
      removeSelectedCircleAvatar();
      textController.clear();
      setTextEditing(false);
    } else {
      removeSelectedCircleAvatar();
      deleteEvent(event);
      _databaseProvider.updateEvent(event);
      setTextEditing(false);
    }
  }

  void transferEvent(Event currentEvent, List<Note> noteList) {
    final event = Event(
      text: currentEvent.text,
      time: DateFormat('yyyy-MM-dd kk:mm').format(
        DateTime.now(),
      ),
      noteId: noteList[state.selectedIndex].id,
      indexOfCircleAvatar: currentEvent.indexOfCircleAvatar,
    );
    _databaseProvider.insertEvent(event);
  }

  void removeSelectedCircleAvatar() {
    state.indexOfSelectedCircleAvatar = null;
    emit(state.copyWith(
        indexOfSelectedCircleAvatar: state.indexOfSelectedCircleAvatar));
  }

  void deleteEvent(Event event) {
    _databaseProvider.deleteEvent(event);
    state.eventList.remove(event);
    emit(state.copyWith(eventList: state.eventList));
  }

  void setSelectedIndex(int selectedIndex) =>
      emit(state.copyWith(selectedIndex: selectedIndex));

  void sendEvent(TextEditingController textController) async {
    final event = Event(
      indexOfCircleAvatar: state.indexOfSelectedCircleAvatar ??
          state.indexOfSelectedCircleAvatar,
      noteId: state.note.id,
      text: textController.text,
      time: DateFormat('yyyy-MM-dd kk:mm').format(
        DateTime.now(),
      ),
    );
    if (textController.text.isNotEmpty) {
      state.eventList.insert(
        0,
        event,
      );
      event.id = await _databaseProvider.insertEvent(event);
      textController.clear();
      emit(state.copyWith(eventList: state.eventList));
    }
  }

  void editEvent(Event event, TextEditingController textController) {
    setTextEditing(true);
    textController.text = event.text;
    state.indexOfSelectedCircleAvatar = event.indexOfCircleAvatar;
  }
}
