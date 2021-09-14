import '../page.dart';

class MessagesState {
  int selectedIconIndex = 0;

  bool isSearching = false;
  bool isOnEdit = false;
  bool isOnSelectionMode = false;
  bool showingFavourites = false;

  List<Event> events;
  Set<Event> selected = {};

  MessagesState(this.events);

  MessagesState copyWith({
    bool? isSearching,
    int? selectedIconIndex,
    bool? isOnEdit,
    bool? isOnSelectionMode,
    bool? showingFavourites,
    List<Event>? events,
    List<Event>? eventsToDisplay,
    Set<Event>? selected,
  }) {
    final state = MessagesState(events ?? this.events);
    state.selectedIconIndex = selectedIconIndex ?? this.selectedIconIndex;
    state.isSearching = isSearching ?? this.isSearching;
    state.isOnEdit = isOnEdit ?? this.isOnEdit;
    state.isOnSelectionMode = isOnSelectionMode ?? this.isOnSelectionMode;
    state.showingFavourites = showingFavourites ?? this.showingFavourites;
    state.events = events ?? this.events;
    state.selected = selected ?? this.selected;
    return state;
  }

  bool areAllFavourites() {
    for (final event in selected) {
      if (!event.isFavourite) {
        return false;
      }
    }
    return true;
  }
}
