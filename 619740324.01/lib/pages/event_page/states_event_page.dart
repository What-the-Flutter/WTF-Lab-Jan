import '../../note.dart';

class StatesEventPage {
  final int selectedEventIndex;
  final bool isEditing;
  final bool isWriting;
  final Note? note;
  final String time;
  final String date;

  const StatesEventPage({
    this.isWriting = false,
    this.time = '',
    this.date = '',
    this.note,
    this.selectedEventIndex = -1,
    this.isEditing = false,
  });

  StatesEventPage copyWith({
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
      selectedEventIndex: selectedEventIndex ?? this.selectedEventIndex,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}
