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
  CubitEventPage(state) : super(state);

  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void init() async {
    setCurrentEventsList(
        await _databaseProvider.fetchEventsList(state.note.noteId));
    initSharedPreferences();
  }

  void setAddingPhotoState(bool isAddingPhoto) =>
      emit(state.copyWith(isAddingPhoto: isAddingPhoto));

  void setSendButtonState(bool isSendPhotoButton) =>
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

  void setSelectedIcon(int index) =>
      emit(state.copyWith(selectedIconIndex: index));

  void setSelectedDate(String selectedDate) =>
      emit(state.copyWith(selectedDate: selectedDate ?? selectedDate));

  void setSelectedTime(String selectedTime) =>
      emit(state.copyWith(selectedTime: selectedTime));

  void changeAppBar() => setSelectedEventState(!state.isEventSelected);

  void initSharedPreferences() {
    state.isDateTimeModification =
        SharedPreferencesProvider().fetchDateTimeModification();
    state.isBubbleAlignment =
        SharedPreferencesProvider().fetchBubbleAlignment();
    state.isCenterDateBubble =
        SharedPreferencesProvider().fetchCenterDateBubble();
  }

  void resetDateTimeModifications() {
    state.selectedTime = null;
    state.selectedDate = null;
    emit(state.copyWith(
        selectedTime: state.selectedTime, selectedDate: state.selectedDate));
  }

  void editText(int index, String text) {
    state.currentEventsList[index].text = text;
    state.currentEventsList[index].circleAvatarIndex = state.selectedIconIndex;
    setTextEditState(false);
  }

  void sortEventsByDate() {
    state.currentEventsList
      ..sort((a, b) {
        var aDate = DateFormat().add_yMMMd().parse(a.date);
        var bDate = DateFormat().add_yMMMd().parse(b.date);
        return bDate.compareTo(aDate);
      });
    emit(state.copyWith(currentEventsList: state.currentEventsList));
  }

  void deleteEvent(int index) {
    _databaseProvider.deleteEvent(state.currentEventsList[index]);
    state.currentEventsList.removeAt(index);
    updateCurrentNoteSubtitle();
    emit(state.copyWith(currentEventsList: state.currentEventsList));
  }

  void removeSelectedIcon() {
    state.selectedIconIndex = null;
    emit(state.copyWith(selectedIconIndex: state.selectedIconIndex));
  }

  void updateCurrentNoteSubtitle() {
    if (state.currentEventsList.isNotEmpty) {
      if (state.currentEventsList[0].imagePath == null) {
        state.note.subtitle =
            '${state.currentEventsList[0].text}  ${state.currentEventsList[0].time}';
      } else {
        state.note.subtitle = 'Image';
      }
    } else {
      state.note.subtitle = 'No events. Click to create one';
    }
    _databaseProvider.updateNote(state.note);
  }

  void addEvent(String text) async {
    final event = Event(
      date: state.selectedDate ??
          DateFormat.yMMMd().format(
            DateTime.now(),
          ),
      imagePath: null,
      circleAvatarIndex: state.selectedIconIndex,
      text: text,
      currentNoteId: state.note.noteId,
      time: state.selectedTime ??
          DateFormat('hh:mm a').format(
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
      date: state.selectedDate ??
          DateFormat.yMMMd().format(
            DateTime.now(),
          ),
      time: state.selectedTime ??
          DateFormat('hh:mm a').format(
            DateTime.now(),
          ),
      text: '',
      imagePath: savedImage.path,
      currentNoteId: state.note.noteId,
    );
    event.eventId = await _databaseProvider.insertEvent(event);
    setAddingPhotoState(false);
    state.currentEventsList.insert(0, event);
    updateCurrentNoteSubtitle();
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
