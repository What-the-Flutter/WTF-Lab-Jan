import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../data/database_provider.dart';
import '../data/shared_preferences_provider.dart';
import '../event.dart';
import '../note.dart';
import 'states_event_page.dart';

class CubitEventPage extends Cubit<StatesEventPage> {
  CubitEventPage(state) : super(state);

  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void init() async {
    final eventsList = <Event>[];
    emit(state.copyWith(eventList: eventsList));
    setTextSearch(false);
    setSelectedIndex(0);
    setWriting(false);
    setTextEditing(false);
    initSharedPreferences();
    setEditingPhotoState(false);
    initEventList();
  }

  void initEventList() async {
    emit(
      state.copyWith(
        eventList: await _databaseProvider.dbEventList(state.note.id)
          ..sort(
            (a, b) {
              var aDate = DateFormat().add_yMMMd().parse(a.date);
              var bDate = DateFormat().add_yMMMd().parse(b.date);
              return bDate.compareTo(aDate);
            },
          ),
      ),
    );
  }

  void setEventList(List<Event> eventList) async {
    emit(state.copyWith(eventList: eventList));
  }

  void initSharedPreferences() {
    emit(state.copyWith(
        isDateTimeModification:
            SharedPreferencesProvider().fetchDateTimeModification()));
    emit(state.copyWith(
        isBubbleAlignment: SharedPreferencesProvider().fetchBubbleAlignment()));
    emit(state.copyWith(
        isCenterDateBubble:
            SharedPreferencesProvider().fetchCenterDateBubble()));
  }

  void setNote(Note note) => emit(state.copyWith(note: note));

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
      time: DateFormat.jm().format(DateTime.now()),
      date: currentEvent.date,
      noteId: noteList[state.selectedIndex].id,
      imagePath: currentEvent.imagePath,
      indexOfCircleAvatar: currentEvent.indexOfCircleAvatar,
    );
    _databaseProvider.insertEvent(event);
  }

  void removeSelectedCircleAvatar() {
    int indexOfSelectedCircleAvatar;
    emit(state.copyWith(
        indexOfSelectedCircleAvatar: indexOfSelectedCircleAvatar));
  }

  void deleteEvent(Event event) {
    _databaseProvider.deleteEvent(event);
    state.eventList.remove(event);
    emit(state.copyWith(eventList: state.eventList));
  }

  void setWriting(bool isWriting) => emit(state.copyWith(isWriting: isWriting));

  void setSelectedIndex(int selectedIndex) =>
      emit(state.copyWith(selectedIndex: selectedIndex));

  void setTime(String time) => emit(state.copyWith(time: time));

  void setData(String date) => emit(state.copyWith(date: date));

  Future<void> addImageEventFromResource(File image) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final saved = await image.copy('${appDir.path}/$fileName');
    final event = Event(
      time: state.time ?? DateFormat.jm().format(DateTime.now()),
      text: '',
      imagePath: saved.path,
      date: state.date ?? DateFormat.yMMMd().format(DateTime.now()),
      noteId: state.note.id,
      isSelected: false,
    );
    event.id = await _databaseProvider.insertEvent(event);
    state.eventList.insert(0, event);
    setEditingPhotoState(false);
    emit(
      state.copyWith(
        eventList: state.eventList
          ..sort(
            (a, b) {
              var aDate = DateFormat().add_yMMMd().parse(a.date);
              var bDate = DateFormat().add_yMMMd().parse(b.date);
              return bDate.compareTo(aDate);
            },
          ),
      ),
    );
    emit(state.copyWith(note: state.note));
  }

  void setEditingPhotoState(bool isEditingPhoto) =>
      emit(state.copyWith(isEditingPhoto: isEditingPhoto));

  void sendEvent(TextEditingController textController) async {
    final event = Event(
      indexOfCircleAvatar: state.indexOfSelectedCircleAvatar ??
          state.indexOfSelectedCircleAvatar,
      noteId: state.note.id,
      text: textController.text,
      time: state.time ?? DateFormat.jm().format(DateTime.now()),
      date: state.date ?? DateFormat.yMMMd().format(DateTime.now()),
    );
    if (textController.text.isNotEmpty) {
      state.eventList.insert(
        0,
        event,
      );
      emit(
        state.copyWith(
          eventList: state.eventList
            ..sort(
              (a, b) {
                var aDate = DateFormat().add_yMMMd().parse(a.date);
                var bDate = DateFormat().add_yMMMd().parse(b.date);
                return bDate.compareTo(aDate);
              },
            ),
        ),
      );
      event.id = await _databaseProvider.insertEvent(event);
      removeSelectedCircleAvatar();
      textController.clear();
      setWriting(false);
      emit(state.copyWith(eventList: state.eventList));
    }
  }

  void editEvent(Event event, TextEditingController textController) {
    setTextEditing(true);
    textController.text = event.text;
    setIndexOfSelectedCircleAvatar(event.indexOfCircleAvatar);
  }
}
