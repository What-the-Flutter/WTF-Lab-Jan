import 'package:cool_notes/models/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/note_repository.dart';
import 'starred_notes_event.dart';
import 'starred_notes_state.dart';

class StarredNotesBloc extends Bloc<StarredNotesEvent, StarredNotesState> {
  final NoteRepository noteRepository;
  final NoteCategory category;

  StarredNotesBloc(
    StarredNotesState initialState, {
    required this.noteRepository,
    required this.category,
  }) : super(initialState);

  @override
  Stream<StarredNotesState> mapEventToState(StarredNotesEvent event) async* {
    if (event is FetchStarredNotesEvent) {
      yield const FetchingStarredNotesState();
      yield await _fetchStarredNotes();
    } else if (event is DeleteFromStarredNotesEvent) {
      await noteRepository.switchStar([event.note]);
      yield await _fetchStarredNotes();
    }
  }

  Future<StarredNotesState> _fetchStarredNotes() async {
    final notes = await noteRepository.fetchStarredNotes(category);
    return FetchedStarredNotesState(notes);
  }
}
