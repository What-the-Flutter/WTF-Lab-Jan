import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../event.dart';
import '../note.dart';
import '../utils/database.dart';
import '../utils/shared_preferences_provider.dart';
import 'states_event_page.dart';

class CubitEventPage extends Cubit<StatesEventPage> {
  CubitEventPage() : super(StatesEventPage());

  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void init(Note note) async {
    setCurrentNote(note);
    setCurrentEventsList(<Event>[]);
    setSelectedIconIndex(-1);
    setSelectedEventState(false);
    setTextEditState(false);
    setTextSearchState(false);
    setAddingPhotoState(false);
    setSendPhotoButtonState(true);
    setSelectedItemIndex(0);
    setSelectedPageReplyIndex(0);
    setSelectedDate('');
    setSelectedTime('');
    initSharedPreferences();
    setCurrentEventsList(
        await _databaseProvider.fetchEventsList(state.note.noteId));
  }

  void setCurrentNote(Note note) => emit(state.copyWith(note: note));

  void setAddingPhotoState(bool isAddingPhoto) =>
      emit(state.copyWith(isAddingPhoto: isAddingPhoto));

  void setSendPhotoButtonState(bool isSendPhotoButton) =>
      emit(state.copyWith(isSendPhotoButton: isSendPhotoButton));

  void setTextEditState(bool isEditing) =>
      emit(state.copyWith(isEditing: isEditing));

  void setTextSearchState(bool isSearch) =>
      emit(state.copyWith(isSearch: isSearch));

  void setSelectedEventState(bool isEventSelected) =>
      emit(state.copyWith(isEventSelected: isEventSelected));

  void setSelectedItemIndex(int selectedItemIndex) =>
      emit(state.copyWith(selectedItemIndex: selectedItemIndex));

  void setSelectedPageReplyIndex(int selectedPageReplyIndex) =>
      emit(state.copyWith(selectedPageReplyIndex: selectedPageReplyIndex));

  void setCurrentEventsList(List<Event> currentEventsList) =>
      emit(state.copyWith(currentEventsList: currentEventsList));

  void setSelectedIconIndex(int index) =>
      emit(state.copyWith(selectedIconIndex: index));

  void setSelectedDate(String selectedDate) =>
      emit(state.copyWith(selectedDate: selectedDate ?? selectedDate));

  void setSelectedTime(String selectedTime) =>
      emit(state.copyWith(selectedTime: selectedTime));

  void changeAppBar() => setSelectedEventState(!state.isEventSelected);

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

  void resetDateTimeModifications() =>
      emit(state.copyWith(selectedTime: '', selectedDate: ''));

  void editText(int index, String text) {
    state.currentEventsList[index].text = text;
    state.currentEventsList[index].circleAvatarIndex = state.selectedIconIndex;
    setTextEditState(false);
  }

  void sortEventsByDate() {
    if (state.currentEventsList != null) {
      state.currentEventsList
        ..sort(
          (a, b) {
            final aDate = DateFormat().add_yMMMd().parse(a.date);
            final bDate = DateFormat().add_yMMMd().parse(b.date);
            return bDate.compareTo(aDate);
          },
        );
      emit(state.copyWith(currentEventsList: state.currentEventsList));
    }
  }

  void deleteEvent(int index) {
    _databaseProvider.deleteEvent(state.currentEventsList[index]);
    state.currentEventsList.removeAt(index);
    emit(state.copyWith(currentEventsList: state.currentEventsList));
  }

  void removeSelectedIcon() => emit(state.copyWith(selectedIconIndex: -1));

  void updateNote() => _databaseProvider.updateNote(state.note);

  void addEvent(String text) async {
    final event = Event(
      date: state.selectedDate != ''
          ? state.selectedDate
          : DateFormat.yMMMd().format(
              DateTime.now(),
            ),
      imagePath: null,
      circleAvatarIndex: state.selectedIconIndex,
      text: text,
      currentNoteId: state.note.noteId,
      time: state.selectedTime != ''
          ? state.selectedTime
          : DateFormat('hh:mm a').format(
              DateTime.now(),
            ),
    );
    state.currentEventsList.insert(0, event);
    emit(state.copyWith(currentEventsList: state.currentEventsList));
    event.eventId = await _databaseProvider.insertEvent(event);
  }

  Future<void> addImageEvent(File image) async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final savedImage = await image.copy('${appDirectory.path}/$fileName');
    final event = Event(
      date: state.selectedDate != ''
          ? state.selectedDate
          : DateFormat.yMMMd().format(
              DateTime.now(),
            ),
      time: state.selectedTime != ''
          ? state.selectedTime
          : DateFormat('hh:mm a').format(
              DateTime.now(),
            ),
      text: '',
      imagePath: savedImage.path,
      currentNoteId: state.note.noteId,
    );
    event.circleAvatarIndex = -1;
    setAddingPhotoState(false);
    state.currentEventsList.insert(0, event);
    event.eventId = await _databaseProvider.insertEvent(event);
  }

  void transferEvent(List<Note> noteList, int index) async {
    final replySubtitle = state.currentEventsList[index].imagePath == null
        ? '${state.currentEventsList[index].text}  ${state.currentEventsList[index].time}'
        : 'Image';
    final event = Event(
      date: state.currentEventsList[index].date,
      text: state.currentEventsList[index].text,
      time: state.currentEventsList[index].time,
      imagePath: state.currentEventsList[index].imagePath,
      currentNoteId: noteList[state.selectedPageReplyIndex].noteId,
      circleAvatarIndex: state.currentEventsList[index].circleAvatarIndex,
    );
    noteList[state.selectedPageReplyIndex].subtitle = replySubtitle;
    deleteEvent(index);
    event.eventId = await _databaseProvider.insertEvent(event);
  }
}
