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
  final bool switchedStar;

  const FetchedStarredNotesState(this.notes, {this.switchedStar = false});

  @override
  List<Object?> get props => [switchedStar];
}
