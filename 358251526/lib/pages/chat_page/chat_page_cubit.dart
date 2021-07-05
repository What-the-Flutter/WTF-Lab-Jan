import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_journal/domain.dart';

part 'chat_page_state.dart';

class ChatPageCubit extends Cubit<ChatPageState> {
  ChatPageCubit(Category category, List<Category> categoriesList)
      : super(
          ChatPageState(
            categotiesList: categoriesList,
            isEditing: false,
            category: category,
            eventSelected: false,
            indexOfSelectedEvent: 0,
            isSending: false,
          ),
        );

  void changeIndexOfSelectedIvent(int index) {
    emit(
      state.copyWith(indexOfSelectedEvent: index),
    );
  }

  void swapAppBar() {
    emit(
      state.copyWith(eventSelected: !state.eventSelected),
    );
  }

  void setEditEvent(bool isEditing) {
    emit(
      state.copyWith(isEditing: isEditing),
    );
  }

  void addEvent(Event event) {
    state.category.events.insert(0, event);
    emit(
      state.copyWith(category: state.category),
    );
  }

  void editText(int index, String text) {
    state.category.events[index].text = text;
    emit(
      state.copyWith(category: state.category),
    );
  }

  void deleteEvent(int index) {
    state.category.events.removeAt(index);
    emit(
      state.copyWith(category: state.category),
    );
  }

  void setEventText(int index, String text) {
    state.category.events[index].text = text;
    emit(
      state.copyWith(category: state.category),
    );
  }

  void setSending(bool isSending){
    emit(
      state.copyWith(isSending: isSending),
    );
  }

  void changeEventCategory(int eventIndex, int categoryIndex) {
    state.categotiesList[categoryIndex].events.insert(
      0,
      Event(
        state.category.events[eventIndex].text,
        DateTime.now(),
      ),
    );
    state.category.events.removeAt(eventIndex);
    emit(
      state.copyWith(
          category: state.category, categoriesList: state.categotiesList),
    );
  }
}
