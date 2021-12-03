import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../event.dart';
import '../../note.dart';
import 'states_event_page.dart';

class CubitEventPage extends Cubit<StatesEventPage> {
  CubitEventPage() : super(const StatesEventPage());

  void init(Note note) {
    setNote(note);
  }

  void setWriting(bool isWriting) => emit(state.copyWith(isWriting: isWriting));

  void setNote(Note note) => emit(state.copyWith(note: note));

  void setTextEditing(bool isEditing) =>
      emit(state.copyWith(isEditing: isEditing));

  void deleteEvent(int selectedEventIndex) {
    state.eventList.remove(state.eventList[selectedEventIndex]);
    emit(state.copyWith(eventList: state.eventList));
  }

  void editText(int selectedEventIndex, String text) {
    if (text.isNotEmpty) {
      state.eventList[selectedEventIndex].text = text;
      setTextEditing(false);
    } else {
      deleteEvent(selectedEventIndex);
      setTextEditing(false);
    }
  }


  void updateBookmark(Event event) {
    event.isBookmark = !event.isBookmark;
    setEventList(state.eventList);
  }

  void setEventList(List<Event> eventLis) =>
      emit(state.copyWith(eventList: eventLis));

  void setSelectedEventIndex(int selectedEventIndex) =>
      emit(state.copyWith(selectedEventIndex: selectedEventIndex));

  void sendEvent(String text) {
    final event = Event(
      text: text,
      isBookmark: false,
      time: state.time == ''
          ? DateFormat.jms().format(DateTime.now())
          : state.time,
      date: state.date == ''
          ? DateFormat.yMMMd().format(DateTime.now())
          : state.date,
    );
    if (text.isNotEmpty) {
      final updatedList = [...state.eventList, event]..sort(
          (a, b) {
            final aDate = DateFormat().add_jms().parse(a.time);
            final bDate = DateFormat().add_jms().parse(b.time);
            return bDate.compareTo(aDate);
          },
        );
      setWriting(false);
      emit(state.copyWith(eventList: updatedList));
    }
  }
}
