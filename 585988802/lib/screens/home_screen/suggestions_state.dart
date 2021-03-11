import '../../models/suggestion.dart';

class SuggestionsState {
  final List<Suggestion> suggestionList;
  final Suggestion selectedSuggestion;

  const SuggestionsState(this.suggestionList, this.selectedSuggestion);

  SuggestionsState copyWith({
    final List<Suggestion> suggestionList,
    final Suggestion selectedSuggestion,
  }) {
    return SuggestionsState(
      suggestionList ?? this.suggestionList,
      selectedSuggestion ?? this.selectedSuggestion,
    );
  }
}
