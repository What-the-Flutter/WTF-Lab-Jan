import 'package:equatable/equatable.dart';

import '../../../../../models/note.dart';
import '../../../../../models/tag.dart';

class SearchState extends Equatable {
  final List<Note> notes;
  final List<Tag> tags;
  final Tag? selectedTag;

  SearchState({required this.notes, required this.tags, this.selectedTag});

  SearchState copyWith({Tag? selectedTag}) {
    return SearchState(notes: notes, tags: tags, selectedTag: selectedTag);
  }

  @override
  List<Object?> get props => [notes, tags, selectedTag];
}
