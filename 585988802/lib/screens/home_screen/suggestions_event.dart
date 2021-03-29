import '../../models/suggestion.dart';

abstract class SuggestionEvent {
  const SuggestionEvent();
}

class SuggestionListInit extends SuggestionEvent {
  const SuggestionListInit();
}

class SuggestionEventMessageDistribute extends SuggestionEvent {
  const SuggestionEventMessageDistribute();
}

class SuggestionListSortByPinned extends SuggestionEvent {
  final List<Suggestion> suggestionList;

  const SuggestionListSortByPinned(this.suggestionList);
}

class SuggestionSelected extends SuggestionEvent {
  final Suggestion selectedSuggestion;

  const SuggestionSelected(this.selectedSuggestion);
}

class SuggestionAdded extends SuggestionEvent {
  final Suggestion suggestion;
  final List<Suggestion> suggestionList;

  const SuggestionAdded(this.suggestion,this.suggestionList);
}

class SuggestionUpdated extends SuggestionEvent {
  const SuggestionUpdated();
}

class SuggestionListUpdate extends SuggestionEvent {
  const SuggestionListUpdate();
}

class SuggestionPinned extends SuggestionEvent {
  final Suggestion selectedSuggestion;

  const SuggestionPinned(this.selectedSuggestion);
}

class SuggestionUnpinned extends SuggestionEvent {
  final Suggestion selectedSuggestion;

  const SuggestionUnpinned(this.selectedSuggestion);
}

class SuggestionDeleted extends SuggestionEvent {
  final List<Suggestion> suggestionList;

  const SuggestionDeleted(this.suggestionList);
}

class SuggestionEdited extends SuggestionEvent {
  final String editedNameOfSuggestion;
  final Suggestion selectedSuggestion;

  const SuggestionEdited(this.editedNameOfSuggestion, this.selectedSuggestion);
}
