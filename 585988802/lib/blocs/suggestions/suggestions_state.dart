import 'package:equatable/equatable.dart';
import '../../models/list_view_suggestion.dart';

abstract class SuggestionsState extends Equatable {
  const SuggestionsState();

  @override
  List<Object> get props => [];
}

class SuggestionsLoadInProgress extends SuggestionsState {}

class SuggestionsLoadSuccess extends SuggestionsState {
  final List<ListViewSuggestion> suggestions;

  const SuggestionsLoadSuccess([this.suggestions = const []]);

  @override
  List<Object> get props => [suggestions];

  @override
  String toString() => 'SuggestionsLoadSuccess { suggestions: $suggestions }';
}

class SuggestionsLoadFailure extends SuggestionsState {}
