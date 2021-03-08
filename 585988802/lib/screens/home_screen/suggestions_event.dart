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

  const SuggestionAdded(this.suggestion);
}

class SuggestionUpdated extends SuggestionEvent {
  const SuggestionUpdated();
}

class SuggestionListUpdate extends SuggestionEvent {
  const SuggestionListUpdate();
}

class SuggestionPinned extends SuggestionEvent {
  const SuggestionPinned();
}

class SuggestionUnpinned extends SuggestionEvent {
  const SuggestionUnpinned();
}

class SuggestionDeleted extends SuggestionEvent {
  const SuggestionDeleted();
}

class SuggestionEdited extends SuggestionEvent {
  final String editedNameOfSuggestion;

  const SuggestionEdited(this.editedNameOfSuggestion);
}
