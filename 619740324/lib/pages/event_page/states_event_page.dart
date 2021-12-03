import '../../event.dart';
import '../../note.dart';

class StatesEventPage {
  final int selectedEventIndex;
  final bool isEditing;
  final bool isWriting;
  final Note? note;
  final String time;
  final String date;
  final List<Event> eventList;

  const StatesEventPage({
    this.isWriting = false,
    this.time = '',
    this.date = '',
    this.note,
    this.selectedEventIndex = -1,
    this.isEditing = false,
    this.eventList = const [],
  });

  StatesEventPage copyWith({
    List<Event>? eventList,
    String? time,
    String? date,
    Note? note,
    bool? isWriting,
    bool? isEditing,
    int? selectedEventIndex,
  }) {
    return StatesEventPage(
      isWriting: isWriting ?? this.isWriting,
      note: note ?? this.note,
      time: time ?? this.time,
      eventList: eventList ?? this.eventList,
      selectedEventIndex: selectedEventIndex ?? this.selectedEventIndex,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}
