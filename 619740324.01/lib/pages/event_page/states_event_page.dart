import '../../event.dart';
import '../../note.dart';

class StatesEventPage {
  final int selectedEventIndex;
  final int selectedCircleAvatar;
  final int selectedNoteIndex;
  final bool isEventEditing;
  final bool isEventPressed;
  final bool isEditingPhoto;
  final bool isWriting;
  final bool isChoosingCircleAvatar;
  final bool isTextSearch;
  final Note? note;
  final String time;
  final String date;
  final List<Note> noteList;
  final List<Event> eventList;

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
    this.isEditingPhoto = false,
    this.noteList = const [],
    this.eventList = const [],
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
    bool? isEditingPhoto,
    int? selectedEventIndex,
    int? selectedCircleAvatar,
    int? selectedNoteIndex,
    List<Note>? noteList,
    List<Event>? eventList,
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
      eventList: eventList ?? this.eventList,
      isEditingPhoto: isEditingPhoto ?? this.isEditingPhoto,
    );
  }
}
