import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../event.dart';
import '../../note.dart';
import 'states_event_page.dart';

class CubitEventPage extends Cubit<StatesEventPage> {
  CubitEventPage() : super(const StatesEventPage());

  void init(Note note) {
    setNote(note);
    setTextEditing(false);
  }

  void setWriting(bool isWriting) => emit(state.copyWith(isWriting: isWriting));

  void setNote(Note? note) => emit(state.copyWith(note: note));

  void setTextEditing(bool isEditing) =>
      emit(state.copyWith(isEditing: isEditing));

  void deleteEvent(int selectedEventIndex) {
    state.note?.eventList.remove(state.note?.eventList[selectedEventIndex]);
    setNote(state.note);
  }

  void editText(int selectedEventIndex, String text) {
    if (text.isNotEmpty) {
      state.note?.eventList[selectedEventIndex].text = text;
      setTextEditing(false);
      setWriting(false);
    } else {
      deleteEvent(selectedEventIndex);
      setTextEditing(false);
      setWriting(false);
    }
  }


  void updateBookmark(Event event) {
    //todo
    event.isBookmark = !event.isBookmark;
    setNote(state.note);
  }

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
      final updatedList = [...state.note!.eventList, event]..sort(
          (a, b) {
            final aDate = DateFormat().add_jms().parse(a.time);
            final bDate = DateFormat().add_jms().parse(b.time);
            return bDate.compareTo(aDate);
          },
        );
      state.note!.eventList = updatedList;
      state.note!.subTittleEvent = text;
      emit(state.copyWith(note: state.note));
      setWriting(false);
    }
  }
}
