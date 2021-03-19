import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../note_page/note.dart';
import 'event.dart';

part 'events_state.dart';

class EventCubit extends Cubit<EventsState> {
  EventCubit(EventsState state) : super(state);

  void setEditState(bool isEditing) =>
      emit(state.copyWith(isEditing: isEditing));

  void setIndexOfSelectedElement(int index) =>
      emit(state.copyWith(indexOfSelectedElement: index));

  void setEventSelectedState(bool isEventSelected) =>
      emit(state.copyWith(eventSelected: isEventSelected));

  void setIconButtonSearchPressedState(bool isIconButtonSearchPressed) => emit(
      state.copyWith(isIconButtonSearchPressed: isIconButtonSearchPressed));

  void setWritingState(bool isWriting) =>
      emit(state.copyWith(isWriting: isWriting));

  void setIndexOfSelectedTile(int index) =>
      emit(state.copyWith(selectedTile: index));

  void deleteEvent(int index) {
    state.note.eventList.removeAt(index);
    if (state.note.eventList.isEmpty) {
      state.note.subTittleEvent = 'Add event';
    } else {
      state.note.subTittleEvent = state.note.eventList[0].text;
    }
    emit(state.copyWith(eventList: state.eventList));
  }

  void setCircleAvatar(CircleAvatar circleAvatar) =>
      emit(state.copyWith(circleAvatar: circleAvatar));

  void sendEvent(TextEditingController textController) {
    state.note.eventList.insert(
      0,
      Event(
        text: textController.text,
        time: DateFormat('yyyy-MM-dd kk:mm').format(
          DateTime.now(),
        ),
        circleAvatar: state.circleAvatar ?? state.circleAvatar,
      ),
    );
    state.note.subTittleEvent = state.note.eventList[0].text;
    textController.clear();
    emit(state.copyWith(note: state.note));
  }

  void editEvent(int index, TextEditingController textController) {
    setEditState(true);
    textController.text = state.note.eventList[index].text;
  }

  void editText(int index, TextEditingController textController) {
    state.note.eventList[index].text = textController.text;
    textController.clear();
    setEditState(false);
  }
}
