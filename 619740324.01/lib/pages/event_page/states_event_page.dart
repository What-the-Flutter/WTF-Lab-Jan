import '../../note.dart';

class StatesEventPage {
  final int selectedEventIndex;
  final int selectedCircleAvatar;
  final int selectedNoteIndex;
  final bool isEventEditing;
  final bool isEventPressed;
  final bool isWriting;
  final bool isChoosingCircleAvatar;
  final bool isTextSearch;
  final Note? note;
  final String time;
  final String date;
  final List<Note> noteList;

  const StatesEventPage({
    this.isWriting = false,
    this.time = '',
    this.date = '',
    this.note,
    this.selectedEventIndex = -1,
    this.selectedCircleAvatar = -1,
    this.selectedNoteIndex = 0,
    this.isEventEditing = false,
    this.isTextSearch = false,
    this.isChoosingCircleAvatar = false,
    this.isEventPressed = false,
    this.noteList = const [],
  });

  StatesEventPage copyWith({
    String? time,
    String? date,
    Note? note,
    bool? isWriting,
    bool? isEventEditing,
    bool? isChoosingCircleAvatar,
    bool? isTextSearch,
    bool? isEventPressed,
    int? selectedEventIndex,
    int? selectedCircleAvatar,
    int? selectedNoteIndex,
    List<Note>? noteList,
  }) {
    return StatesEventPage(
      isWriting: isWriting ?? this.isWriting,
      note: note ?? this.note,
      time: time ?? this.time,
      selectedEventIndex: selectedEventIndex ?? this.selectedEventIndex,
      selectedCircleAvatar: selectedCircleAvatar ?? this.selectedCircleAvatar,
      selectedNoteIndex: selectedNoteIndex ?? this.selectedNoteIndex,
      isChoosingCircleAvatar:
          isChoosingCircleAvatar ?? this.isChoosingCircleAvatar,
      isEventEditing: isEventEditing ?? this.isEventEditing,
      noteList: noteList ?? this.noteList,
      isTextSearch: isTextSearch ?? this.isTextSearch,
      isEventPressed: isEventPressed ?? this.isEventPressed,
    );
  }
}
