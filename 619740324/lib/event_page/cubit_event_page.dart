import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../event.dart';
import 'states_event_page.dart';

class CubitEventPage extends Cubit<StatesEventPage> {
  CubitEventPage(state) : super(state);

  void setTextSearch(bool isSearch) =>
      emit(state.copyWith(isSearch: isSearch));

  void setTextEditing(bool isEditing) =>
      emit(state.copyWith(isEditing: isEditing));

  void setIndexOfSelectedElement(int indexOfSelectedElement) =>
      emit(state.copyWith(indexOfSelectedElement: indexOfSelectedElement));

  void setSelectedCircleAvatar(CircleAvatar circleAvatar) =>
      emit(state.copyWith(selectedCircleAvatar: circleAvatar));

  void editText(int index, TextEditingController textController,CircleAvatar circleAvatar){
    if (textController.text.isNotEmpty) {
      state.eventList[index].text = textController.text;
      state.eventList[index].circleAvatar= circleAvatar;
      removeSelectedCircleAvatar();
      textController.clear();
      setTextEditing(false);
    } else {
      removeSelectedCircleAvatar();
      deleteEvent(index);
      setTextEditing(false);
    }
  }

  void removeSelectedCircleAvatar(){
    state.selectedCircleAvatar = null;
    emit(state.copyWith(selectedCircleAvatar: state.selectedCircleAvatar));
  }

  void deleteEvent(int index) {
    state.eventList.removeAt(index);
    emit(state.copyWith(eventList: state.eventList));
  }

  void setSelectedIndex(int selectedIndex)=>
      emit(state.copyWith(selectedIndex: selectedIndex));

  void sendEvent(TextEditingController textController,CircleAvatar circleAvatar){
    if (textController.text.isNotEmpty) {
      state.eventList.insert(
        0,
        Event(
          circleAvatar: circleAvatar,
          text: textController.text,
          time: DateFormat('yyyy-MM-dd kk:mm').format(
            DateTime.now(),
          ),
          isSelected: false,
        ),
      );
      textController.clear();
      emit(state.copyWith(eventList: state.eventList));
    }
  }

  void editEvent(int index,TextEditingController textController){
    setTextEditing(true);
    textController.text = state.eventList[index].text;
  }

  void setEventList(List<Event> newEventList) =>
      emit(state.copyWith(newEventList: newEventList));
}
