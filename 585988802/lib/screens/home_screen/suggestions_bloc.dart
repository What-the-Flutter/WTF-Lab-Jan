import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../db_helper/db_helper.dart';
import '../../models/event_message.dart';
import '../../models/suggestion.dart';
import 'suggestions_event.dart';
import 'suggestions_state.dart';

class SuggestionsBloc extends Bloc<SuggestionEvent, SuggestionsState> {
  SuggestionsBloc(SuggestionsState initialState) : super(initialState);

  final DBHelper _dbHelper = DBHelper();

  @override
  Stream<SuggestionsState> mapEventToState(SuggestionEvent event) async* {
    if (event is SuggestionListInit) {
      yield* _mapSuggestionListInitToState();
    } else if (event is SuggestionAdded) {
      yield* _mapSuggestionAddedToState(event);
    } else if (event is SuggestionDeleted) {
      yield* _mapSuggestionDeletedToState(event);
    } else if (event is SuggestionPinned) {
      yield* _mapSuggestionPinnedToState();
    } else if (event is SuggestionUnpinned) {
      yield* _mapSuggestionUnpinnedToState();
    } else if (event is SuggestionSelected) {
      yield* _mapSuggestionSelectedToState(event);
    } else if (event is SuggestionEventMessageDistribute) {
      yield* _mapSuggestionEventMessageDistributeToState();
    } else if (event is SuggestionListSortByPinned) {
      yield* _mapSuggestionListSortByPinnedToState(event);
    } else if (event is SuggestionEdited) {
      yield* _mapSuggestionEditedToState(event);
    } else if (event is SuggestionListUpdate) {
      yield* _mapSuggestionListUpdateToState();
    }
  }

  Stream<SuggestionsState>
      _mapSuggestionEventMessageDistributeToState() async* {
    final eventMessageList = await _dbHelper.dbEventMessagesList();
    final suggestionList = List<Suggestion>.from(state.suggestionList);

    for (var i = 0; i < suggestionList.length; i++) {
      var localEventMessageList = <EventMessage>[];
      for (var j = 0; j < eventMessageList.length; j++) {
        if (eventMessageList[j].idOfSuggestion == suggestionList[i].id) {
          localEventMessageList.insert(0, eventMessageList[j]);
        }
      }
      suggestionList[i].eventMessagesList = localEventMessageList;
    }

    yield state.copyWith(suggestionList: suggestionList);
  }

  Stream<SuggestionsState> _mapSuggestionListSortByPinnedToState(
      SuggestionListSortByPinned event) async* {
    yield state.copyWith(
        suggestionList: event.suggestionList
          ..sort((a, b) => (b.isPinned).compareTo(a.isPinned)));
  }

  Stream<SuggestionsState> _mapSuggestionSelectedToState(
      SuggestionSelected event) async* {
    yield state.copyWith(selectedSuggestion: event.selectedSuggestion);
  }

  Stream<SuggestionsState> _mapSuggestionListInitToState() async* {
    add(SuggestionListUpdate());
    yield state.copyWith();
  }

  Stream<SuggestionsState> _mapSuggestionAddedToState(
      SuggestionAdded event) async* {
    if (event.suggestion != null) {
      final id = await _dbHelper.insertSuggestion(event.suggestion);
      event.suggestion.id = id;
      yield state.copyWith(
          suggestionList: state.suggestionList..add(event.suggestion));
    }
  }

  Stream<SuggestionsState> _mapSuggestionDeletedToState(
      SuggestionDeleted event) async* {
    _dbHelper.deleteSuggestion(state.selectedSuggestion);
    yield state.copyWith(
      suggestionList: state.suggestionList..remove(state.selectedSuggestion),
    );
  }

  Stream<SuggestionsState> _mapSuggestionPinnedToState() async* {
    state.selectedSuggestion.isPinned = 1;
    _dbHelper.updateSuggestion(state.selectedSuggestion);
    yield state.copyWith();
  }

  Stream<SuggestionsState> _mapSuggestionUnpinnedToState() async* {
    state.selectedSuggestion.isPinned = 0;
    _dbHelper.updateSuggestion(state.selectedSuggestion);
    yield state.copyWith();
  }

  Stream<SuggestionsState> _mapSuggestionEditedToState(
      SuggestionEdited event) async* {
    state.selectedSuggestion.nameOfSuggestion = event.editedNameOfSuggestion;
    _dbHelper.updateSuggestion(state.selectedSuggestion);
    yield state.copyWith();
  }

  Stream<SuggestionsState> _mapSuggestionListUpdateToState() async* {
    yield state.copyWith(suggestionList: await _dbHelper.dbSuggestionsList());
  }
}
