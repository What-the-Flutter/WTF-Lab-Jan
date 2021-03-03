import 'package:equatable/equatable.dart';
import '../../models/suggestion.dart';

abstract class SuggestionsState extends Equatable {
  const SuggestionsState();

  @override
  List<Object> get props => [];
}

class SuggestionsLoadInProgress extends SuggestionsState {}

class SuggestionsLoadSuccess extends SuggestionsState {
  final List<Suggestion> suggestions;

  const SuggestionsLoadSuccess(this.suggestions);

  @override
  List<Object> get props => [suggestions];

  @override
  String toString() => 'SuggestionsLoadSuccess { suggestions: $suggestions }';
}

class SuggestionsLoadFailure extends SuggestionsState {}
