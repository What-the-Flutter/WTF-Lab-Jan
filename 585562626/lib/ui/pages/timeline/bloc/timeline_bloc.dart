import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repository/note_repository.dart';
import 'timeline_event.dart';
import 'timeline_state.dart';

class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  final NoteRepository noteRepository;

  TimelineBloc(
    TimelineState initialState, {
    required this.noteRepository,
  }) : super(initialState);

  @override
  Stream<TimelineState> mapEventToState(TimelineEvent event) async* {
    if (event is FetchNotesEvent) {
      yield const FetchingNotesState();
      yield await _fetchNotes();
    } else if (state is FetchedNotesState) {
      final currentState = state as FetchedNotesState;
      if (event is ApplyFilterEvent) {
        final filtered = currentState.notes
            .where(
              (element) =>
                  (event.selectedCategories.isNotEmpty
                      ? event.selectedCategories.contains(element.category)
                      : true) &&
                  (event.selectedTags.isNotEmpty
                      ? event.selectedTags
                          .any((tag) => element.note.text?.contains(tag.name) ?? false)
                      : true) &&
                  (event.query.isNotEmpty
                      ? (element.note.text?.contains(event.query) ?? false)
                      : true),
            )
            .toList();
        filtered.sort((e1, e2) => e2.note.created.compareTo(e1.note.created));
        yield FetchedNotesState(currentState.notes, filtered);
      }
    }
  }

  Future<TimelineState> _fetchNotes() async {
    final notes = await noteRepository.fetchNotesWithCategories();
    return FetchedNotesState(notes, notes);
  }
}
