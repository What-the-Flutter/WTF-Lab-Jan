import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../data/db_provider.dart';
import '../note_page/note.dart';
import 'event.dart';

part 'events_state.dart';

class EventCubit extends Cubit<EventsState> {
  EventCubit(EventsState state) : super(state);
  final DBProvider _dbProvider = DBProvider();
  void initEventList() async {
    final eventsList = <Event>[];
    await _dbProvider.dbEventList(eventsList, state.note.id);
    emit(state.copyWith(eventList: eventsList));
  }

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
    _dbProvider.deleteEvent(state.eventList[index]);
    state.eventList.removeAt(index);
    if (state.eventList.isEmpty) {
      state.note.subTittleEvent = 'Add event';
    } else {
      state.note.subTittleEvent = state.eventList[0].text;
    }
    emit(state.copyWith(eventList: state.eventList));
  }

  void setIndexOfCircleAvatar(int indexOfCircleAvatar) =>
      emit(state.copyWith(indexOfCircleAvatar: indexOfCircleAvatar));

  void sendEvent(TextEditingController textController) async {
    final event = Event(
      text: textController.text,
      time: DateFormat('yyyy-MM-dd kk:mm').format(
        DateTime.now(),
      ),
      indexOfCircleAvatar:
          state.indexOfCircleAvatar ?? state.indexOfCircleAvatar,
      noteId: state.note.id,
    );
    state.eventList.insert(
      0,
      event,
    );
    event.id = await _dbProvider.insertEvent(event);
    state.note.subTittleEvent = state.eventList[0].text;
    textController.clear();
    emit(state.copyWith(note: state.note));
  }

  void editEvent(int index, TextEditingController textController) {
    setEditState(true);
    textController.text = state.eventList[index].text;
  }

  void editText(int index, TextEditingController textController) {
    state.eventList[index].text = textController.text;
    _dbProvider.updateEvent(state.eventList[index]);
    textController.clear();
    setEditState(false);
  }
}
