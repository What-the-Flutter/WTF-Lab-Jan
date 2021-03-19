part of 'events_cubit.dart';

class EventsState {
  bool eventSelected = true;
  int indexOfSelectedElement = 0;
  bool isEditing = false;
  bool isIconButtonSearchPressed = false;
  bool isWriting = false;
  int selectedTile = 0;
  final Note note;
  List<Event> eventList = [];
  int indexOfCircleAvatar;

  EventsState copyWith({
    bool eventSelected,
    int indexOfSelectedElement,
    bool isEditing,
    bool isIconButtonSearchPressed,
    bool isWriting,
    int selectedTile,
    Note note,
    List<Event> eventList,
    int indexOfCircleAvatar,
  }) {
    var state = EventsState(note ?? this.note);
    state.eventSelected = eventSelected ?? this.eventSelected;
    state.indexOfSelectedElement =
        indexOfSelectedElement ?? this.indexOfSelectedElement;
    state.isEditing = isEditing ?? this.isEditing;
    state.isIconButtonSearchPressed =
        isIconButtonSearchPressed ?? this.isIconButtonSearchPressed;
    state.isWriting = isWriting ?? this.isWriting;
    state.selectedTile = selectedTile ?? this.selectedTile;
    state.eventList = eventList ?? this.eventList;
    state.indexOfCircleAvatar = indexOfCircleAvatar;
    return state;
  }

  EventsState(this.note);
}
