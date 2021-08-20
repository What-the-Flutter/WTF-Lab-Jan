import 'package:equatable/equatable.dart';

import '../../../../models/note.dart';

abstract class StarredNotesState extends Equatable {
  const StarredNotesState();

  @override
  List<Object?> get props => [];
}

class FetchingStarredNotesState extends StarredNotesState {
  const FetchingStarredNotesState();
}

class InitialStarredNotesState extends FetchedStarredNotesState {
  const InitialStarredNotesState() : super(const []);
}

class FetchedStarredNotesState extends StarredNotesState {
  final List<Note> notes;
  final int? deleteAt;
  final Note? noteToDelete;

  const FetchedStarredNotesState(this.notes, {this.deleteAt, this.noteToDelete});

  FetchedStarredNotesState copyWith({List<Note>? notes, int? deleteAt, Note? noteToDelete}) {
    return FetchedStarredNotesState(
      notes ?? this.notes,
      deleteAt: deleteAt ?? this.deleteAt,
      noteToDelete: noteToDelete ?? this.noteToDelete,
    );
  }

  @override
  List<Object?> get props => [deleteAt, noteToDelete];
}
