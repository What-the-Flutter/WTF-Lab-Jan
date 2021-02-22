import '../page.dart';

abstract class EventsEvent {
  const EventsEvent();
}

class ShowFavourites extends EventsEvent {
  final bool showingFavourites;
  const ShowFavourites(this.showingFavourites);
}

class SetSelectionMode extends EventsEvent {
  final bool isOnSelectionMode;
  const SetSelectionMode(this.isOnSelectionMode);
}

class SetOnEdit extends EventsEvent {
  final bool isOnEdit;
  const SetOnEdit(this.isOnEdit);
}

class SetOnSearch extends EventsEvent {
  final bool isSearching;
  const SetOnSearch(this.isSearching);
}

class EventsDeleted extends EventsEvent {
  const EventsDeleted();
}

class AddedToFavourites extends EventsEvent {
  const AddedToFavourites();
}

class EventSelected extends EventsEvent {
  final Event event;
  const EventSelected(this.event);
}

class EventAdded extends EventsEvent {
  final Event event;
  const EventAdded(this.event);
}

class EventEdited extends EventsEvent {
  final String description;
  const EventEdited(this.description);
}

class IconSelected extends EventsEvent {
  final int selectedIndex;
  const IconSelected(this.selectedIndex);
}