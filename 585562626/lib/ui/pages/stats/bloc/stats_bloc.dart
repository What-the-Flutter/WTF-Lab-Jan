import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/category.dart';
import '../../../../models/note_with_category.dart';
import '../../../../repository/note_repository.dart';
import '../models/category_count.dart';
import 'stats_event.dart';
import 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final NoteRepository noteRepository;

  StatsBloc(StatsState initialState, {required this.noteRepository}) : super(initialState);

  @override
  Stream<StatsState> mapEventToState(StatsEvent event) async* {
    if (event is FetchDataEvent) {
      yield const FetchingDataState();
      final notes = await noteRepository.fetchNotesWithCategories();
      final notesForCategories = groupBy<NoteWithCategory, Category>(
        notes,
        (noteWithCategory) => noteWithCategory.category,
      ).entries.map((e) => CategoryCount(e.key, e.value.length));
      yield FetchedNotesState(notes, categoryCountData: notesForCategories.toList());
    }
  }
}
