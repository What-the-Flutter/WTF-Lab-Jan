import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';

import '../../db_helper/db_helper.dart';
import '../../models/event_message.dart';
import 'timeline_event.dart';
import 'timeline_state.dart';

class TimelineScreenBloc
    extends Bloc<TimelineScreenEvent, TimelineScreenState> {
  TimelineScreenBloc(TimelineScreenState initialState) : super(initialState);

  final DBHelper _dbHelper = DBHelper();

  @override
  Stream<TimelineScreenState> mapEventToState(
      TimelineScreenEvent event) async* {
    if (event is TimelineEventMessageListInit) {
      yield* _mapEventMessageListInitToState(event);
    } else if (event is TimelineUpdateEventMessageList) {
      yield* _mapUpdateToState();
    } else if (event is TimelineSearchIconButtonUnpressed) {
      yield* _mapSearchIconButtonUnpressedToState(event);
    } else if (event is TimelineSearchIconButtonPressed) {
      yield* _mapSearchIconButtonPressedToState(event);
    } else if (event is TimelineFavoriteButPressed) {
      yield* _mapFavoriteButPressedToState(event);
    } else if (event is TimelineEventMessageListFiltered) {
      yield* _mapEventMessageListFilteredToState(event);
    } else if (event is TimelineEventMessageListFilteredReceived) {
      yield* _mapEventMessageListFilteredReceivedToState();
    } else if (event is TimelineEventMessageSelected) {
      yield* _mapEventMessageSelectedToState(event);
    } else if (event is TimelineEditingModeChanged) {
      yield* _mapEditingModeChangedToState(event);
    } else if (event is TimelineEventMessageDeleted) {
      yield* _mapEventMessageDeletedToState(event);
    } else if (event is TimelineEventMessageEdited) {
      yield* _mapEventMessageEditedToState(event);
    } else if (event is TimelineEventMessageToFavorite) {
      yield* _mapEventMessageToFavoriteToState(event);
    } else if (event is TimelineTagDeleted) {
      yield* _mapTagDeletedToState(event);
    } else if (event is TimelineUpdateTagList) {
      yield* _mapUpdateTagListToState();
    } else if (event is TimelineEventMessageListFilteredBySuggestionName) {
      yield* _mapEventMessageListFilteredBySuggestionName(event);
    }
  }

  Stream<TimelineScreenState> _mapEventMessageListInitToState(
      TimelineEventMessageListInit event) async* {
    final eventMessageList = await _dbHelper.dbEventMessagesList();
    eventMessageList.sort((a, b) {
      final aDate = DateFormat.yMMMd().add_jm().parse(a.time);
      final bDate = DateFormat.yMMMd().add_jm().parse(b.time);
      return bDate.compareTo(aDate);
    });
    yield state.copyWith(
      filteredEventMessageList: eventMessageList,
      eventMessageList: eventMessageList,
      isSearchIconButtonPressed: false,
      isCategorySelected: false,
      isEditing: false,
      isFavoriteButPressed: false,
      suggestionList: await _dbHelper.dbSuggestionsList(),
    );
  }

  Stream<TimelineScreenState> _mapSearchIconButtonUnpressedToState(
      TimelineSearchIconButtonUnpressed event) async* {
    yield state.copyWith(
      filteredEventMessageList: event.eventMessageList,
      isSearchIconButtonPressed: !event.isSearchIconButtonPressed,
    );
  }

  Stream<TimelineScreenState> _mapSearchIconButtonPressedToState(
      TimelineSearchIconButtonPressed event) async* {
    yield state.copyWith(
      isSearchIconButtonPressed: !event.isSearchIconButtonPressed,
    );
  }

  Stream<TimelineScreenState> _mapFavoriteButPressedToState(
      TimelineFavoriteButPressed event) async* {
    yield state.copyWith(
      isFavoriteButPressed: !event.isFavoriteButPressed,
    );
  }

  Stream<TimelineScreenState> _mapEventMessageListFilteredToState(
      TimelineEventMessageListFiltered event) async* {
    yield state.copyWith(
      filteredEventMessageList: event.eventMessageList
          .where((eventMessage) => eventMessage.isImageMessage == 1
              ? 'Image'
                  .toLowerCase()
                  .contains(event.searchEventMessage.toLowerCase())
              : eventMessage.text
                  .toLowerCase()
                  .contains(event.searchEventMessage.toLowerCase()))
          .toList(),
    );
  }

  Stream<TimelineScreenState> _mapEventMessageListFilteredBySuggestionName(
      TimelineEventMessageListFilteredBySuggestionName event) async* {
    yield state.copyWith(
      filteredEventMessageList: event.eventMessageList
          .where((eventMessage) =>
              eventMessage.nameOfSuggestion.toLowerCase() ==
              event.nameOfSuggestion.toLowerCase())
          .toList(),
    );
  }

  Stream<TimelineScreenState>
      _mapEventMessageListFilteredReceivedToState() async* {
    yield state.copyWith();
  }

  Stream<TimelineScreenState> _mapEventMessageSelectedToState(
      TimelineEventMessageSelected event) async* {
    yield state.copyWith(
      selectedEventMessage: event.eventMessage,
    );
  }

  Stream<TimelineScreenState> _mapUpdateToState() async* {
    final eventMessageList = await _dbHelper.dbEventMessagesList();
    eventMessageList.sort((a, b) {
      final aDate = DateFormat.yMMMd().add_jm().parse(a.time);
      final bDate = DateFormat.yMMMd().add_jm().parse(b.time);
      return bDate.compareTo(aDate);
    });
    yield state.copyWith(
      filteredEventMessageList: eventMessageList,
      eventMessageList: eventMessageList,
    );
  }

  Stream<TimelineScreenState> _mapEditingModeChangedToState(
      TimelineEditingModeChanged event) async* {
    yield state.copyWith(
      isEditing: event.isEditing,
    );
  }

  Stream<TimelineScreenState> _mapEventMessageToFavoriteToState(
      TimelineEventMessageToFavorite event) async* {
    event.eventMessage.isFavorite =
        (event.eventMessage.isFavorite == 1) ? 0 : 1;
    _dbHelper.updateEventMessage(event.eventMessage);
    yield state.copyWith(
      selectedEventMessage: event.eventMessage,
    );
  }

  Stream<TimelineScreenState> _mapEventMessageDeletedToState(
      TimelineEventMessageDeleted event) async* {
    _dbHelper.deleteEventMessage(state.selectedEventMessage);
    event.eventMessageList.remove(state.selectedEventMessage);
    yield state.copyWith(
      eventMessageList: event.eventMessageList,
      filteredEventMessageList: event.eventMessageList,
    );
  }

  Stream<TimelineScreenState> _mapEventMessageEditedToState(
      TimelineEventMessageEdited event) async* {
    final index = event.eventMessageList.indexOf(state.selectedEventMessage);
    final eventMessage = EventMessage(
      id: state.selectedEventMessage.id,
      idOfSuggestion: state.selectedEventMessage.idOfSuggestion,
      nameOfSuggestion: state.selectedEventMessage.nameOfSuggestion,
      time: state.selectedEventMessage.time,
      text: event.editedNameOfEventMessage,
      isFavorite: state.selectedEventMessage.isFavorite,
      imagePath: state.selectedEventMessage.imagePath,
      isImageMessage: state.selectedEventMessage.isImageMessage,
      categoryImagePath: state.selectedEventMessage.categoryImagePath,
      nameOfCategory: state.selectedEventMessage.nameOfCategory,
    );
    _dbHelper.updateEventMessage(eventMessage);
    event.eventMessageList[index] = eventMessage;
    yield state.copyWith(
      eventMessageList: event.eventMessageList,
      filteredEventMessageList: event.eventMessageList,
    );
  }

  Stream<TimelineScreenState> _mapTagDeletedToState(
      TimelineTagDeleted event) async* {
    _dbHelper.deleteTag(event.tag);
    event.tagList.remove(event.tag);
    yield state.copyWith(
      tagList: event.tagList,
    );
  }

  Stream<TimelineScreenState> _mapUpdateTagListToState() async* {
    final dbTagList = await _dbHelper.dbTagList();
    yield state.copyWith(
      tagList: dbTagList,
    );
  }
}
