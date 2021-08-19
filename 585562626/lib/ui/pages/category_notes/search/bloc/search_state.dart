import 'package:equatable/equatable.dart';

import '../../../../../models/note.dart';
import '../../../../../models/tag.dart';

class SearchState extends Equatable {
  final List<Note> notes;
  final List<Note> filteredNotes;
  final List<Tag> tags;
  final List<Tag> selectedTags;
  final String query;

  SearchState({
    required this.notes,
    required this.tags,
    this.selectedTags = const [],
    this.filteredNotes = const [],
    this.query = '',
  });

  SearchState copyWith({
    List<Tag>? selectedTags,
    List<Note>? filteredNotes,
    String? query,
  }) {
    return SearchState(
      notes: notes,
      tags: tags,
      selectedTags: selectedTags ?? this.selectedTags,
      filteredNotes: filteredNotes ?? this.filteredNotes,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [notes, tags, selectedTags, filteredNotes, query];
}
