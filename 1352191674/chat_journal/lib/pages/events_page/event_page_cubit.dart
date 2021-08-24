import 'dart:io';

import 'package:chat_journal/models/note_model.dart';
import 'package:chat_journal/models/event_model.dart';
import 'package:chat_journal/services/db_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

part 'event_page_state.dart';

class EventCubit extends Cubit<EventsState> {
  final DBProvider _dbProvider = DBProvider();

  EventCubit()
      : super(
          EventsState(
            isBubbleAlignment: false,
            isDateTimeModification: false,
          ),
        );

  void init(Note note) {
    setNote(note);
    setEventListState(<Event>[]);
    setWritingState(false);
    setAllBookmarkState(false);
    setIconButtonSearchPressedState(false);
    setWritingBottomTextFieldState(false);
    setIndexOfCircleAvatar(0);
    setIndexOfSelectedTile(0);
    setEditingPhotoState(false);
    setEditState(false);
    setEventSelectedState(false);
    initEventList();
  }

  void initEventList() async {
    emit(
      state.copyWith(
        eventList: await _dbProvider.dbEventList(state.note!.id)
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

  void setEventListState(List<Event> eventList) =>
      emit(state.copyWith(eventList: eventList));

  void setNote(Note note) => emit(state.copyWith(note: note));

  void setDate(String date) => emit(state.copyWith(date: date));

  void transferEvent(Event currentEvent, List<Note> noteList) {
    final eventId = state.eventList!.length;
    final event = Event(
      text: currentEvent.text,
      time: DateFormat.jm().format(
        DateTime.now(),
      ),
      date: currentEvent.date,
      bookmarkCreateTime: currentEvent.bookmarkCreateTime,
      isBookmarked: currentEvent.isBookmarked,
      noteId: noteList[state.selectedTile!].id,
      indexOfCircleAvatar: currentEvent.indexOfCircleAvatar,
      imagePath: currentEvent.imagePath,
      isSelected: false,
      id: eventId + 1,
    );
    _dbProvider.insertEvent(event);
  }

  void setWritingBottomTextFieldState(bool isWritingBottomTextField) =>
      emit(state.copyWith(isWritingBottomTextField: isWritingBottomTextField));

  void setEditState(bool isEditing) =>
      emit(state.copyWith(isEditing: isEditing));

  void setDateTime(String dateTime) => emit(state.copyWith(dateTime: dateTime));

  void setHourTime(String hourTime) => emit(state.copyWith(hourTime: hourTime));

  void setSelectedElement(Event event) =>
      emit(state.copyWith(selectedElement: event));

  void setEventSelectedState(bool isEventSelected) =>
      emit(state.copyWith(eventSelected: isEventSelected));

  void setIconButtonSearchPressedState(bool isIconButtonSearchPressed) => emit(
      state.copyWith(isIconButtonSearchPressed: isIconButtonSearchPressed));

  void setWritingState(bool isWriting) =>
      emit(state.copyWith(isWriting: isWriting));

  void setIndexOfSelectedTile(int index) =>
      emit(state.copyWith(selectedTile: index));

  void setEventState(Event event) {
    event.isSelected = !event.isSelected;
    emit(state.copyWith(event: event));
  }

  void deleteEvent(Event event) {
    _dbProvider.deleteEvent(event);
    state.eventList!.remove(event);
    if (state.eventList!.isEmpty) {
      state.note!.subTitleEvent = 'Add event';
    } else {
      state.note!.subTitleEvent = state.eventList![0].text;
    }
    emit(state.copyWith(eventList: state.eventList));
  }

  void setBookmarkState(Event event) {
    event.isBookmarked = !event.isBookmarked;
    event.bookmarkCreateTime = DateFormat.yMMMd().format(DateTime.now());
    emit(state.copyWith(event: event));
    _dbProvider.updateEvent(event);
  }

  void setEditingPhotoState(bool isEditingPhoto) =>
      emit(state.copyWith(isEditingPhoto: isEditingPhoto));

  void setAllBookmarkState(bool isAllBookmarked) =>
      emit(state.copyWith(isAllBookmarked: isAllBookmarked));

  Future<void> addImageEventFromResource(File image) async {
    final eventId = state.eventList!.length;
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final saved = await image.copy('${appDir.path}/$fileName');
    final event = Event(
      time: DateFormat.jm().format(
        DateTime.now(),
      ),
      text: '',
      imagePath: saved.path,
      date: DateFormat.yMMMd('en_US').format(
        DateTime.now(),
      ),
      bookmarkCreateTime: '',
      isBookmarked: false,
      noteId: state.note!.id,
      isSelected: false,
      id: eventId + 1,
      indexOfCircleAvatar: state.indexOfCircleAvatar!,
    );
    event.id = await _dbProvider.insertEvent(event);

    state.eventList!.insert(0, event);
    setEditingPhotoState(false);
    emit(state.copyWith(note: state.note));
  }

  void setIndexOfCircleAvatar(int indexOfCircleAvatar) =>
      emit(state.copyWith(indexOfCircleAvatar: indexOfCircleAvatar));

  void sendEvent(String text) async {
    final event = Event(
      text: text,
      time: state.hourTime ??
          DateFormat.jm().format(
            DateTime.now(),
          ),
      isBookmarked: false,
      bookmarkCreateTime: '',
      date: state.dateTime ?? DateFormat.yMMMd().format(DateTime.now()),
      indexOfCircleAvatar:
          state.indexOfCircleAvatar ?? state.indexOfCircleAvatar,
      noteId: state.note!.id,
      isSelected: false,
      imagePath: '',
    );
    state.eventList!.insert(0, event);
    emit(
      state.copyWith(
        eventList: state.eventList!
          ..sort(
            (a, b) {
              var aDate = DateFormat().add_yMMMd().parse(a.date);
              var bDate = DateFormat().add_yMMMd().parse(b.date);
              return bDate.compareTo(aDate);
            },
          ),
      ),
    );
    event.id = await _dbProvider.insertEvent(event);
    state.note!.subTitleEvent = state.eventList![0].text;
    emit(state.copyWith(note: state.note));
  }

  void editText(Event event, String text) {
    event.text = text;
    event.indexOfCircleAvatar = state.indexOfCircleAvatar!;
    _dbProvider.updateEvent(event);
    setEditState(false);
  }
}
