import '../event.dart';
import '../note_page.dart';

class StatesEventPage {
  List<Event> currentEventsList = [];
  NotePage note;
  int selectedIconIndex;
  bool isEventSelected = false;
  bool isEditing = false;
  bool isSearch = false;
  int selectedItemIndex = 0;
  int selectedPageReplyIndex = 0;

  StatesEventPage copyWith({
    List<Event> currentEventsList,
    NotePage note,
    int selectedIconIndex,
    bool isEventSelected,
    bool isEditing,
    bool isSearch,
    int selectedItemIndex,
    int selectedPageReplyIndex,
  }) {
    var state = StatesEventPage(note ?? this.note);
    state.currentEventsList = currentEventsList ?? this.currentEventsList;
    state.selectedIconIndex = selectedIconIndex ?? this.selectedIconIndex;
    state.isEventSelected = isEventSelected ?? this.isEventSelected;
    state.isEditing = isEditing ?? this.isEditing;
    state.isSearch = isSearch ?? this.isSearch;
    state.selectedItemIndex = selectedItemIndex ?? this.selectedItemIndex;
    state.selectedPageReplyIndex =
        selectedPageReplyIndex ?? this.selectedPageReplyIndex;
    return state;
  }

  StatesEventPage(this.note);
}
