import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../event.dart';
import '../utils/database.dart';
import 'states_event_page.dart';

class CubitEventPage extends Cubit<StatesEventPage> {
  CubitEventPage(state) : super(state);

  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void initEventsList() async {
    await _databaseProvider.downloadEventsList(
        state.currentEventsList, state.note.noteId);
    emit(state.copyWith(currentEventsList: state.currentEventsList));
  }

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

  void setSelectedIcon(int index) {
    emit(state.copyWith(selectedIconIndex: index));
  }

  void openSearchAppBar(TextEditingController textEditingController) {
    setTextSearchState(!state.isSearch);
    textEditingController.addListener(() {
      emit(state.copyWith(currentEventsList: state.currentEventsList));
    });
  }

  void editEvent(int index, TextEditingController textEditingController) {
    setTextEditState(true);
    textEditingController.text = state.currentEventsList[index].text;
    textEditingController.selection = TextSelection(
      baseOffset: textEditingController.text.length,
      extentOffset: textEditingController.text.length,
    );
  }

  void editText(int index, TextEditingController textEditingController) {
    state.currentEventsList[index].text = textEditingController.text;
    state.currentEventsList[index].circleAvatarIndex = state.selectedIconIndex;
    textEditingController.clear();
    setTextEditState(false);
  }

  void deleteEvent(int index) {
    _databaseProvider.deleteEvent(state.currentEventsList[index]);
    state.currentEventsList.removeAt(index);
    emit(state.copyWith(currentEventsList: state.currentEventsList));
  }

  void removeSelectedIcon(){
    state.selectedIconIndex = null;
    emit(state.copyWith(selectedIconIndex: state.selectedIconIndex));
  }

  void updateNoteSubtitle(){
    state.note.subtitle =
    '${state.currentEventsList[0].text}    ${state.currentEventsList[0].time}';
    _databaseProvider.updateNote(state.note);
  }

  void addEvent(TextEditingController textEditingController) async {
    final event = Event(
      circleAvatarIndex: state.selectedIconIndex,
      text: textEditingController.text,
      currentNoteId: state.note.noteId,
      time: DateFormat('dd-MM-yyyy kk:mm').format(DateTime.now()),
    );
    state.currentEventsList.insert(0, event);
    emit(state.copyWith(currentEventsList: state.currentEventsList));
    textEditingController.clear();
    event.eventId = await _databaseProvider.insertEvent(event);
  }
}
