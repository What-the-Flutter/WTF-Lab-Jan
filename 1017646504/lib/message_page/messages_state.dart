import '../entity/page.dart';

class MessagesState {
  int selectedIconIndex = 0;

  bool isSearching = false;
  bool isOnEdit = false;
  bool isOnSelectionMode = false;
  bool showingFavourites = false;
  bool isRightToLeft = false;
  bool isDateCentered = false;
  bool isDateSelected = false;
  bool canSelectImage = true;

  List<Event> events = [];
  Set<Event> selected = {};

  DateTime date = DateTime.now();
  JournalPage page;

  MessagesState(this.page);

  MessagesState copyWith({
    bool? isSearching,
    int? selectedIconIndex,
    bool? isOnEdit,
    bool? isOnSelectionMode,
    bool? showingFavourites,
    bool? isRightToLeft,
    bool? isDateCentered,
    bool? isDateSelected,
    bool? canSelectImage,
    List<Event>? events,
    List<Event>? eventsToDisplay,
    Set<Event>? selected,
    JournalPage? page,
  }) {
    final state = MessagesState(page ?? this.page);
    state.date = date;
    state.events = events ?? this.events;
    state.selectedIconIndex = selectedIconIndex ?? this.selectedIconIndex;
    state.isSearching = isSearching ?? this.isSearching;
    state.isOnEdit = isOnEdit ?? this.isOnEdit;
    state.isOnSelectionMode = isOnSelectionMode ?? this.isOnSelectionMode;
    state.showingFavourites = showingFavourites ?? this.showingFavourites;
    state.isRightToLeft = isRightToLeft ?? this.isRightToLeft;
    state.isDateCentered = isDateCentered ?? this.isDateCentered;
    state.isDateSelected = isDateSelected ?? this.isDateSelected;
    state.events = events ?? this.events;
    state.selected = selected ?? this.selected;
    state.canSelectImage = canSelectImage ?? this.canSelectImage;
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
