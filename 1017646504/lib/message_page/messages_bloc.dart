import 'package:bloc/bloc.dart';

import 'messages_event.dart';
import 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  MessagesBloc(initialState) : super(initialState);

  @override
  Stream<MessagesState> mapEventToState(MessagesEvent event) async* {
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

  Stream<MessagesState> _mapShowFavourites(ShowFavourites event) async* {
    yield state.copyWith(showingFavourites: event.showingFavourites);
  }

  Stream<MessagesState> _mapSetSelectionMode(SetSelectionMode event) async* {
    if (!event.isOnSelectionMode) {
      state.selected..clear();
    }
    yield state.copyWith(
      isOnSelectionMode: event.isOnSelectionMode,
    );
  }

  Stream<MessagesState> _mapSetOnEdit(SetOnEdit event) async* {
    yield state.copyWith(isOnEdit: event.isOnEdit);
  }

  Stream<MessagesState> _mapSetOnSearch(SetOnSearch event) async* {
    yield state.copyWith(isSearching: event.isSearching);
  }

  Stream<MessagesState> _mapEventsDeleted() async* {
    state.selected..forEach((element) => state.events.remove(element));
    yield state.copyWith(selected: {});
  }

  Stream<MessagesState> _mapAddedToFavourites() async* {
    var allFavourites = state.areAllFavourites();
    state.selected..forEach((element) => element.isFavourite = allFavourites ? false : true);
    yield state.copyWith(selected: {});
  }

  Stream<MessagesState> _mapEventSelected(EventSelected event) async* {
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

  Stream<MessagesState> _mapEventAdded(EventAdded event) async* {
    yield state.copyWith(events: state.events..insert(0, event.event));
  }

  Stream<MessagesState> _mapEventEdited(EventEdited event) async* {
    state.selected.first.description = event.description;
    add(const SetOnEdit(false));
    add(const SetSelectionMode(false));
    yield state.copyWith();
  }

  Stream<MessagesState> _mapIconSelected(IconSelected event) async* {
    yield state.copyWith(selectedIconIndex: event.selectedIndex);
  }
}
