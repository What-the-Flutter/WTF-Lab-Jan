import 'package:equatable/equatable.dart';

import '../../../../models/note_with_category.dart';

abstract class TimelineState extends Equatable {
  const TimelineState();

  @override
  List<Object?> get props => [];
}

class FetchingNotesState extends TimelineState {
  const FetchingNotesState();
}

class InitialNotesState extends FetchedNotesState {
  const InitialNotesState() : super(const [], const []);
}

class FetchedNotesState extends TimelineState {
  final List<NoteWithCategory> notes;
  final List<NoteWithCategory> filteredNotes;

  const FetchedNotesState(this.notes, this.filteredNotes);

  @override
  List<Object?> get props => [notes, filteredNotes];
}
