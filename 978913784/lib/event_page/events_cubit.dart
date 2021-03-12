import 'package:flutter_bloc/flutter_bloc.dart';

import '../database_access.dart';
import '../entity/page.dart';
import 'events_state.dart';

class EventCubit extends Cubit<EventsState> {
  DatabaseAccess db = DatabaseAccess();

  EventCubit(EventsState state) : super(state);

  void initialize(JournalPage page) async {
    await db.initialize();
    var events = await db.fetchEvents(page.id);
    events.sort((a, b) => b.creationTime.compareTo(a.creationTime));
    emit(state.copyWith(events: events, page: page));
  }

  void showFavourites(bool showingFavourites) {
    emit(state.copyWith(showingFavourites: showingFavourites));
  }

  void setSelectionMode(bool isOnSelectionMode) {
    if (!isOnSelectionMode) {
      state.selected.clear();
    }
    emit(state.copyWith(isOnSelectionMode: isOnSelectionMode));
  }

  void setOnEdit(bool isOnEdit) {
    emit(state.copyWith(isOnEdit: isOnEdit));
  }

  void setOnSearch(bool isSearching) {
    emit(state.copyWith(isSearching: isSearching));
  }

  void deleteEvents() async {
    state.selected
      ..forEach((event) async {
        state.events.remove(event);
        db.deleteEvent(event);
      });
    emit(state.copyWith(selected: {}));
  }

  void addToFavourites() {
    var allFavourites = state.areAllFavourites();
    state.selected
      ..forEach((event) async {
        event.isFavourite = allFavourites ? false : true;
        db.updateEvent(event);
      });
    emit(state.copyWith(selected: {}));
  }

  void selectEvent(Event event) {
    if (state.isOnSelectionMode) {
      if (state.selected.contains(event)) {
        state.selected.remove(event);
        if (state.selected.isEmpty) {
          state.isOnSelectionMode = false;
        }
      } else {
        state.selected.add(event);
        if (state.isOnEdit && state.selected.length != 1) {
          state.isOnEdit = false;
        }
      }
    }
    emit(state.copyWith());
  }

  Future<void> addEvent(Event event) async {
    if (state.date != null) {
      event.creationTime = state.date;
    }
    state.events..insert(0, event);
    db.insertEvent(event);
    emit(state.copyWith(
        events: state.events
          ..sort((a, b) => b.creationTime.compareTo(a.creationTime))));
  }

  Future<void> editEvent(String description) async {
    state.selected.first.description = description;
    db.updateEvent(state.selected.first);
    setOnEdit(false);
    setSelectionMode(false);
    emit(state.copyWith());
  }

  void acceptForward(JournalPage page) async {
    List forwardedList = state.selected.toList();
    for (var forwardedEvent in forwardedList) {
      forwardedEvent.pageId = page.id;
      db.updateEvent(forwardedEvent);
    }
    setSelectionMode(false);
    emit(state.copyWith(events: await db.fetchEvents(state.page.id)));
  }

  void selectIcon(int selectedIndex) {
    emit(state.copyWith(selectedIconIndex: selectedIndex));
  }

  void setDate(DateTime date) {
    emit(state.copyWith(date: date));
    print(state.date);
  }
}
