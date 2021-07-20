import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../util/db_provider.dart';
import '../../util/domain.dart';

part 'chat_page_state.dart';

class ChatPageCubit extends Cubit<ChatPageState> {
  ChatPageCubit()
      : super(
          ChatPageState(
            isEditing: false,
            eventSelected: false,
            indexOfSelectedEvent: 0,
            isSending: false,
          ),
        );

  final DBProvider _dBProvider = DBProvider();

  void init(Category category) async {
    emit(
      state.copyWith(
        isSending: false,
        isEditing: false,
        eventSelected: false,
        indexOfSelectedEvent: 0,
        events: await _dBProvider.fetchEventsList(category.id),
        category: category,
      ),
    );
  }

  void changeIndexOfSelectedEvent(int index) {
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

  Future<void> addEvent(String text) async {
    final event = Event(
      id: -1,
      text: text,
      dateTime: DateFormat('yyyy-MM-dd kk:mm').format(
        DateTime.now(),
      ),
      categoryId: state.category!.id,
    );
    state.events!.insert(0, event);
    emit(
      state.copyWith(events: state.events),
    );
    event.id = await _dBProvider.insertEvent(event);
  }

  void editText(int index, String text) {
    state.events![index].text = text;
    _dBProvider.updateEvent(state.events![index]);
    emit(
      state.copyWith(events: state.events),
    );
  }

  void deleteEvent(int index) {
    _dBProvider.deleteEvent(state.events![index]);
    state.events!.removeAt(index);
    emit(
      state.copyWith(events: state.events),
    );
  }

  void setEventText(int index, String text) {
    state.events![index].text = text;
    emit(
      state.copyWith(events: state.events),
    );
  }

  void setSending(bool isSending) {
    emit(
      state.copyWith(isSending: isSending),
    );
  }

  void changeEventCategory(int eventIndex, Category category) async {
    final event = Event(
      id: -1,
      categoryId: category.id,
      text: state.events![eventIndex].text,
      dateTime: DateFormat('yyyy-MM-dd kk:mm').format(
        DateTime.now(),
      ),
    );
    deleteEvent(eventIndex);
    event.id = await _dBProvider.insertEvent(event);
    state.events![eventIndex].categoryId = category.id;
  }
}
