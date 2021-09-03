import '../page.dart';

abstract class MessagesEvent {
  const MessagesEvent();
}

class ShowFavourites extends MessagesEvent {
  final bool showingFavourites;

  const ShowFavourites(this.showingFavourites);
}

class SetSelectionMode extends MessagesEvent {
  final bool isOnSelectionMode;

  const SetSelectionMode(this.isOnSelectionMode);
}

class SetOnEdit extends MessagesEvent {
  final bool isOnEdit;

  const SetOnEdit(this.isOnEdit);
}

class SetOnSearch extends MessagesEvent {
  final bool isSearching;

  const SetOnSearch(this.isSearching);
}

class EventsDeleted extends MessagesEvent {
  const EventsDeleted();
}

class AddedToFavourites extends MessagesEvent {
  const AddedToFavourites();
}

class EventSelected extends MessagesEvent {
  final Event event;

  const EventSelected(this.event);
}

class EventAdded extends MessagesEvent {
  final Event event;

  const EventAdded(this.event);
}

class EventEdited extends MessagesEvent {
  final String description;

  const EventEdited(this.description);
}

class IconSelected extends MessagesEvent {
  final int selectedIndex;

  const IconSelected(this.selectedIndex);
}
