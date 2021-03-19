import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../event.dart';
import 'states_event_page.dart';

class CubitEventPage extends Cubit<StatesEventPage> {
  CubitEventPage(state) : super(state);

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

  void openSearchAppBar() {
    setTextSearchState(!state.isSearch);
    state.focusSearchNode.requestFocus();
    state.textSearchController.addListener(() {
      emit(state.copyWith(currentEventsList: state.currentEventsList));
    });
  }

  void editEvent(int index) {
    setTextEditState(true);
    state.textController.text = state.currentEventsList[index].text;
  }

  void editText(int index, CircleAvatar circleAvatar) {
    state.currentEventsList[index].text = state.textController.text;
    state.currentEventsList[index].circleAvatar = circleAvatar;
    state.textController.clear();
    setTextEditState(false);
  }

  void deleteEvent(int index) {
    state.currentEventsList.removeAt(index);
    emit(state.copyWith(currentEventsList: state.currentEventsList));
  }

  void addEvent(CircleAvatar circleAvatar) {
    state.currentEventsList.insert(
      0,
      Event(
        circleAvatar: circleAvatar,
        text: state.textController.text,
        time: DateFormat('dd-MM-yyyy kk:mm').format(DateTime.now()),
        isSelectedEvent: false,
      ),
    );
    state.textController.clear();
    emit(state.copyWith(currentEventsList: state.currentEventsList));
  }
}
