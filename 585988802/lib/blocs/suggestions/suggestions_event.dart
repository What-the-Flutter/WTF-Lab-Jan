import 'package:equatable/equatable.dart';
import '../../models/list_view_suggestion.dart';

abstract class SuggestionsEvent extends Equatable {
  const SuggestionsEvent();

  @override
  List<Object> get props => [];
}

class SuggestionsLoadSuccessEvent extends SuggestionsEvent {}

class SuggestionsAdded extends SuggestionsEvent {
  final ListViewSuggestion suggestion;

  const SuggestionsAdded(this.suggestion);

  @override
  List<Object> get props => [suggestion];

  @override
  String toString() => 'SuggestionAdded { suggestion: $suggestion }';
}

class SuggestionsUpdated extends SuggestionsEvent {
  final ListViewSuggestion suggestion;

  const SuggestionsUpdated(this.suggestion);

  @override
  List<Object> get props => [suggestion];

  @override
  String toString() => 'SuggestionUpdated { suggestion: $suggestion }';
}

class SuggestionsPinnedOrUnpinned extends SuggestionsEvent {
  final ListViewSuggestion suggestion;

  const SuggestionsPinnedOrUnpinned(this.suggestion);

  @override
  List<Object> get props => [suggestion];

  @override
  String toString() => 'SuggestionPinned { suggestion: $suggestion }';
}

class SuggestionsDeleted extends SuggestionsEvent {
  final ListViewSuggestion suggestion;

  const SuggestionsDeleted(this.suggestion);

  @override
  List<Object> get props => [suggestion];

  @override
  String toString() => 'SuggestionDeleted { suggestion: $suggestion }';
}
