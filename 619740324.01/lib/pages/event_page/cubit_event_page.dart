import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../data/database_provider.dart';
import '../../event.dart';
import '../../note.dart';
import 'states_event_page.dart';

class CubitEventPage extends Cubit<StatesEventPage> {
  CubitEventPage() : super(const StatesEventPage());

  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void init(Note note, List<Note> noteList) {
    setNote(note);
    setNoteList(noteList);
    setTextSearch(false);
    setEventEditing(false);
    setEditingPhoto(false);
    removeSelectedCircleAvatar();
    initEventList();
  }

  void setEditingPhoto(bool isEditingPhoto) =>
      emit(state.copyWith(isEditingPhoto: isEditingPhoto));

  void initEventList() async {
    emit(
      state.copyWith(
        eventList: await _databaseProvider.dbEventList(state.note!.id)
          ..sort(
            (a, b) {
              final aDate = DateFormat().add_jms().parse(a.time);
              final bDate = DateFormat().add_jms().parse(b.time);
              return bDate.compareTo(aDate);
            },
          ),
      ),
    );
  }

  void downloadURL(Event event) async {
    await _databaseProvider.downloadURL(event);
  }

  Future<void> addImageEventFromResource(File image) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final saved = await image.copy('${appDir.path}/$fileName');
    final event = Event(
      time: DateFormat.jms().format(DateTime.now()),
      text: '',
      id: const Uuid().v4(),
      imagePath: saved.path,
      bookmarkIndex: 0,
      date: DateFormat.yMMMd().format(DateTime.now()),
      idNote: state.note!.id,
      isSelected: false,
    );
    await _databaseProvider.uploadFile(image, event);
    await _databaseProvider.downloadURL(event);
    _databaseProvider.addEvent(event);
    state.eventList.insert(0, event);
    setEditingPhoto(false);
    emit(
      state.copyWith(
        eventList: state.eventList
          ..sort(
            (a, b) {
              final aDate = DateFormat().add_yMMMd().parse(a.date);
              final bDate = DateFormat().add_yMMMd().parse(b.date);
              return bDate.compareTo(aDate);
            },
          ),
      ),
    );
    emit(state.copyWith(note: state.note));
  }

  void updateEvent(Event event) {
    _databaseProvider.updateEvent(event);
  }

  void transferEvent(Event currentEvent, List<Note> noteList) {
    final event = Event(
      text: currentEvent.text,
      id: currentEvent.id,
      imagePath: currentEvent.imagePath,
      time: DateFormat.jms().format(DateTime.now()),
      date: currentEvent.date,
      bookmarkIndex: currentEvent.bookmarkIndex,
      idNote: noteList[state.selectedNoteIndex].id,
      indexOfCircleAvatar: currentEvent.indexOfCircleAvatar,
    );
    state.noteList[state.selectedNoteIndex].subTittleEvent = currentEvent.text;
    _databaseProvider.addEvent(event);
  }

  void setWriting(bool isWriting) => emit(state.copyWith(isWriting: isWriting));

  void setTextSearch(bool isTextSearch) =>
      emit(state.copyWith(isTextSearch: isTextSearch));

  void setNoteList(List<Note> noteList) =>
      emit(state.copyWith(noteList: noteList));

  void setChoosingCircleAvatar(bool isChoosingCircleAvatar) =>
      emit(state.copyWith(isChoosingCircleAvatar: isChoosingCircleAvatar));

  void setSelectedCircleAvatar(int selectedCircleAvatar) =>
      emit(state.copyWith(selectedCircleAvatar: selectedCircleAvatar));

  void removeSelectedCircleAvatar() =>
      emit(state.copyWith(selectedCircleAvatar: -1));

  void setSelectedNoteIndex(int selectedNoteIndex) =>
      emit(state.copyWith(selectedNoteIndex: selectedNoteIndex));

  void setNote(Note? note) => emit(state.copyWith(note: note));

  void setEventEditing(bool isEventEditing) =>
      emit(state.copyWith(isEventEditing: isEventEditing));

  void setEventPressed(bool isEventPressed) =>
      emit(state.copyWith(isEventPressed: isEventPressed));

  void deleteEvent(int selectedEventIndex) {
    _databaseProvider.deleteEvent(state.eventList[selectedEventIndex]);
    state.eventList.remove(state.eventList[selectedEventIndex]);
    setNote(state.note);
  }

  void editText(int selectedEventIndex, String text) {
    if (text.isNotEmpty) {
      state.eventList[selectedEventIndex].text = text;
      state.eventList[selectedEventIndex].indexOfCircleAvatar =
          state.selectedCircleAvatar;
      updateEvent(state.eventList[selectedEventIndex]);
      setEventEditing(false);
      setWriting(false);
    } else {
      deleteEvent(selectedEventIndex);
      updateEvent(state.eventList[selectedEventIndex]);
      setEventEditing(false);
      setWriting(false);
    }
  }

  void setSelectedEventIndex(int selectedEventIndex) =>
      emit(state.copyWith(selectedEventIndex: selectedEventIndex));

  void setEventList(List<Event> eventList) =>
      emit(state.copyWith(eventList: eventList));

  void sendEvent(String text) async {
    final event = Event(
      text: text,
      imagePath: '',
      id: const Uuid().v4(),
      indexOfCircleAvatar: state.selectedCircleAvatar,
      idNote: state.note!.id,
      bookmarkIndex: 0,
      time: state.time == ''
          ? DateFormat.jms().format(DateTime.now())
          : state.time,
      date: state.date == ''
          ? DateFormat.yMMMd().format(DateTime.now())
          : state.date,
    );
    if (text.isNotEmpty) {
      final updatedList = [...state.eventList, event]..sort(
          (a, b) {
            final aDate = DateFormat().add_jms().parse(a.time);
            final bDate = DateFormat().add_jms().parse(b.time);
            return bDate.compareTo(aDate);
          },
        );
      _databaseProvider.addEvent(event);
      setEventList(updatedList);
      state.note!.subTittleEvent = text;
      setWriting(false);
      setEventPressed(false);
    }
  }
}
