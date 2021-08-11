import 'package:equatable/equatable.dart';

import '../../../models/note.dart';

abstract class StarredNotesEvent extends Equatable {
  const StarredNotesEvent();

  @override
  List<Object?> get props => [];
}

class FetchStarredNotesEvent extends StarredNotesEvent {
  const FetchStarredNotesEvent();
}

class DeleteFromStarredNotesEvent extends StarredNotesEvent {
  final BaseNote note;

  DeleteFromStarredNotesEvent(this.note);

  @override
  List<Object?> get props => [note];
}
