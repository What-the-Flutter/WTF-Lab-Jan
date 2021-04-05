import '../event.dart';
import '../note.dart';

class StatesEventPage {
  Event selectedElement;
  int selectedIndex = 0;
  int indexOfSelectedCircleAvatar;
  bool isEditing = false;
  bool isSearch = false;
  Note note;

  List<Event> eventList = [];

  StatesEventPage(this.note);

  StatesEventPage copyWith({
    List<Event> eventList,
    Note note,
    bool isEditing,
    bool isSearch,
    Event selectedElement,
    int selectedIndex,
    int indexOfSelectedCircleAvatar,
  }) {
    var state = StatesEventPage(note ?? this.note);
    state.eventList = eventList ?? this.eventList;
    state.indexOfSelectedCircleAvatar =
        indexOfSelectedCircleAvatar ?? this.indexOfSelectedCircleAvatar;
    state.selectedIndex = selectedIndex ?? this.selectedIndex;
    state.isEditing = isEditing ?? this.isEditing;
    state.isSearch = isSearch ?? this.isSearch;
    state.selectedElement = selectedElement ?? this.selectedElement;
    return state;
  }
}
