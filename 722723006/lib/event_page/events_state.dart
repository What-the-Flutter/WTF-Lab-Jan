part of 'events_cubit.dart';

class EventsState {
  bool eventSelected = true;
  Event selectedElement;
  bool isEditing = false;
  bool isIconButtonSearchPressed = false;
  bool isWriting = false;
  bool isWritingBottomTextField = false;
  int selectedTile = 0;
  final Note note;
  List<Event> eventList = [];
  int indexOfCircleAvatar;
  bool isEditingPhoto = false;
  String dateTime;
  bool isCenterDateBubble = false;
  bool isBubbleAlignment = false;
  bool isDateTimeModification = false;
  String backgroundImagePath;

  EventsState copyWith({
    bool eventSelected,
    Event selectedElement,
    bool isEditing,
    bool isIconButtonSearchPressed,
    bool isWriting,
    int selectedTile,
    Note note,
    List<Event> eventList,
    bool isWritingBottomTextField,
    int indexOfCircleAvatar,
    bool isEditingPhoto,
    String dateTime,
    bool isCenterDateBubble,
    bool isBubbleAlignment,
    bool isDateTimeModification,
    String backgroundImagePath
  }) {
    var state = EventsState(note ?? this.note);
    state.eventSelected = eventSelected ?? this.eventSelected;
    state.selectedElement = selectedElement ?? this.selectedElement;
    state.isEditing = isEditing ?? this.isEditing;
    state.isIconButtonSearchPressed =
        isIconButtonSearchPressed ?? this.isIconButtonSearchPressed;
    state.isWriting = isWriting ?? this.isWriting;
    state.selectedTile = selectedTile ?? this.selectedTile;
    state.eventList = eventList ?? this.eventList;
    state.indexOfCircleAvatar = indexOfCircleAvatar;
    state.isWritingBottomTextField =
        isWritingBottomTextField ?? this.isWritingBottomTextField;
    state.isEditingPhoto = isEditingPhoto ?? this.isEditingPhoto;
    state.dateTime = dateTime ?? this.dateTime;
    state.isCenterDateBubble = isCenterDateBubble ?? this.isCenterDateBubble;
    state.isBubbleAlignment = isBubbleAlignment ?? this.isBubbleAlignment;
    state.isDateTimeModification =
        isDateTimeModification ?? this.isDateTimeModification;
    state.backgroundImagePath = backgroundImagePath ?? this.backgroundImagePath;
    return state;
  }

  EventsState(this.note);
}
