import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/list_view_suggestion.dart';
import 'suggestions_event.dart';
import 'suggestions_state.dart';

class SuggestionsBloc extends Bloc<SuggestionsEvent, SuggestionsState> {
  List<ListViewSuggestion> suggestionsList;

  SuggestionsBloc({@required this.suggestionsList})
      : super(SuggestionsLoadInProgress());

  @override
  Stream<SuggestionsState> mapEventToState(SuggestionsEvent event) async* {
    if (event is SuggestionsLoadSuccessEvent) {
      yield* _mapSuggestionLoadedToState();
    } else if (event is SuggestionsAdded) {
      yield* _mapSuggestionAddedToState(event);
    } else if (event is SuggestionsUpdated) {
      yield* _mapSuggestionUpdatedToState(event);
    } else if (event is SuggestionsDeleted) {
      yield* _mapSuggestionDeletedToState(event);
    } else if (event is SuggestionsPinnedOrUnpinned) {
      yield* _mapSuggestionPinnedOrUnpinnedToState(event);
    }
  }

  Stream<SuggestionsState> _mapSuggestionLoadedToState() async* {
    try {
      final suggestions = await suggestionsList;
      yield SuggestionsLoadSuccess(suggestions.toList());
    } catch (_) {
      yield SuggestionsLoadFailure();
    }
  }

  Stream<SuggestionsState> _mapSuggestionAddedToState(
      SuggestionsAdded event) async* {
    if (state is SuggestionsLoadSuccess) {
      final updatedSuggestions = List<ListViewSuggestion>.from(
          (state as SuggestionsLoadSuccess).suggestions)
        ..add(event.suggestion);
      yield SuggestionsLoadSuccess(updatedSuggestions);
      _saveSuggestions(updatedSuggestions);
    }
  }

  Stream<SuggestionsState> _mapSuggestionUpdatedToState(
      SuggestionsUpdated event) async* {
    if (state is SuggestionsLoadSuccess) {
      final List<ListViewSuggestion> updatedSuggestions =
          (state as SuggestionsLoadSuccess).suggestions.map((suggestion) {
        return suggestion.nameOfSuggestion == event.suggestion.nameOfSuggestion
            ? event.suggestion.nameOfSuggestion
            : suggestion;
      }).toList();
      yield SuggestionsLoadSuccess(updatedSuggestions);
      _saveSuggestions(updatedSuggestions);
    }
  }

  Stream<SuggestionsState> _mapSuggestionDeletedToState(
      SuggestionsDeleted event) async* {
    if (state is SuggestionsLoadSuccess) {
      final updatedSuggestions = (state as SuggestionsLoadSuccess)
          .suggestions
          .where((suggestion) =>
              suggestion.nameOfSuggestion != event.suggestion.nameOfSuggestion)
          .toList();
      yield SuggestionsLoadSuccess(updatedSuggestions);
      _saveSuggestions(updatedSuggestions);
    }
  }

  Stream<SuggestionsState> _mapSuggestionPinnedOrUnpinnedToState(
      SuggestionsPinnedOrUnpinned event) async* {
    if (state is SuggestionsLoadSuccess) {
      final List<ListViewSuggestion> updatedPinnedSuggestions =
          (state as SuggestionsLoadSuccess).suggestions.map((suggestion) {
        return suggestion.isPinned == event.suggestion.isPinned
            ? event.suggestion.isPinned
            : suggestion;
      }).toList();
      yield SuggestionsLoadSuccess(updatedPinnedSuggestions);
      _saveSuggestions(updatedPinnedSuggestions);
    }
  }

  Future _saveSuggestions(List<ListViewSuggestion> suggestions) async {
    return suggestionsList = suggestions;
  }
}
