import '../event.dart';
import '../note.dart';

class StatesEventPage {
  final Event selectedElement;
  final int selectedIndex;
  final int indexOfSelectedCircleAvatar;
  final bool isEditing;
  final bool isSearch;
  final bool isDateTimeModification;
  final bool isBubbleAlignment;
  final bool isCenterDateBubble;
  final bool isEditingPhoto;
  final bool isWriting;
  final Note note;
  final String date;
  final String time;
  final List<Event> eventList;

  const StatesEventPage({
    this.isWriting,
    this.isEditingPhoto,
    this.date,
    this.time,
    this.note,
    this.selectedElement,
    this.selectedIndex,
    this.indexOfSelectedCircleAvatar,
    this.isEditing,
    this.isSearch,
    this.eventList,
    this.isBubbleAlignment,
    this.isCenterDateBubble,
    this.isDateTimeModification,
  });

  StatesEventPage copyWith({
    List<Event> eventList,
    String date,
    String time,
    Note note,
    bool isWriting,
    bool isEditingPhoto,
    bool isEditing,
    bool isSearch,
    bool isDateTimeModification,
    bool isBubbleAlignment,
    bool isCenterDateBubble,
    Event selectedElement,
    int selectedIndex,
    int indexOfSelectedCircleAvatar,
  }) {
    return StatesEventPage(
      isWriting: isWriting ?? this.isWriting,
      isEditingPhoto: isEditingPhoto ?? this.isEditingPhoto,
      note: note ?? this.note,
      date: date ?? this.date,
      time: time ?? this.time,
      isBubbleAlignment: isBubbleAlignment ?? this.isBubbleAlignment,
      isCenterDateBubble: isCenterDateBubble ?? this.isCenterDateBubble,
      isDateTimeModification:
          isDateTimeModification ?? this.isDateTimeModification,
      eventList: eventList ?? this.eventList,
      indexOfSelectedCircleAvatar: indexOfSelectedCircleAvatar,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isEditing: isEditing ?? this.isEditing,
      isSearch: isSearch ?? this.isSearch,
      selectedElement: selectedElement ?? this.selectedElement,
    );
  }
}
