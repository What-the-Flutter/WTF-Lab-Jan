import 'package:flutter_bloc/flutter_bloc.dart';

import 'events_event.dart';
import 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc(initialState) : super(initialState);

  @override
  Stream<EventsState> mapEventToState(EventsEvent event) async* {
    if (event is ShowFavourites) {
      yield* _mapShowFavourites(event);
    } else if (event is SetSelectionMode) {
      yield* _mapSetSelectionMode(event);
    } else if (event is SetOnEdit) {
      yield* _mapSetOnEdit(event);
    } else if (event is EventsDeleted) {
      yield* _mapEventsDeleted();
    } else if (event is AddedToFavourites) {
      yield* _mapAddedToFavourites();
    } else if (event is EventSelected) {
      yield* _mapEventSelected(event);
    } else if (event is EventAdded) {
      yield* _mapEventAdded(event);
    } else if (event is EventEdited) {
      yield* _mapEventEdited(event);
    } else if (event is IconSelected) {
      yield* _mapIconSelected(event);
    } else if (event is SetOnSearch) {
      yield* _mapSetOnSearch(event);
    }
  }

  Stream<EventsState> _mapShowFavourites(ShowFavourites event) async* {
    yield state.copyWith(showingFavourites: event.showingFavourites);
  }

  Stream<EventsState> _mapSetSelectionMode(SetSelectionMode event) async* {
    if (!event.isOnSelectionMode) {
      state.selected..clear();
    }
    yield state.copyWith(
      isOnSelectionMode: event.isOnSelectionMode,
    );
  }

  Stream<EventsState> _mapSetOnEdit(SetOnEdit event) async* {
    yield state.copyWith(isOnEdit: event.isOnEdit);
  }

  Stream<EventsState> _mapSetOnSearch(SetOnSearch event) async* {
    yield state.copyWith(isSearching: event.isSearching);
  }

  Stream<EventsState> _mapEventsDeleted() async* {
    state.selected..forEach((element) => state.events.remove(element));
    yield state.copyWith(selected: {});
  }

  Stream<EventsState> _mapAddedToFavourites() async* {
    var allFavourites = state.areAllFavourites();
    state.selected
      ..forEach((element) =>
          element.isFavourite =  allFavourites ? false : true);
    yield state.copyWith(selected: {});
  }

  Stream<EventsState> _mapEventSelected(EventSelected event) async* {
    if (state.isOnSelectionMode) {
      if (state.selected.contains(event.event)) {
        state.selected.remove(event.event);
        if (state.selected.isEmpty) {
          state.isOnSelectionMode = false;
        }
      } else {
        state.selected.add(event.event);
        if (state.isOnEdit && state.selected.length != 1) {
          state.isOnEdit = false;
        }
      }
    }
    yield state.copyWith();
  }

  Stream<EventsState> _mapEventAdded(EventAdded event) async* {
    yield state.copyWith(events: state.events..insert(0, event.event));
  }

  Stream<EventsState> _mapEventEdited(EventEdited event) async* {
    state.selected.first.description = event.description;
    add(SetOnEdit(false));
    add(SetSelectionMode(false));
    yield state.copyWith();
  }

  Stream<EventsState> _mapIconSelected(IconSelected event) async* {
    yield state.copyWith(selectedIconIndex: event.selectedIndex);
  }
}
