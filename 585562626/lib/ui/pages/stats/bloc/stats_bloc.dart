import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/category.dart';
import '../../../../models/note_with_category.dart';
import '../../../../repository/category_repository.dart';
import '../../../../repository/note_repository.dart';
import '../models/category_count.dart';
import 'stats_event.dart';
import 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final NoteRepository noteRepository;
  final CategoryRepository categoryRepository;

  StatsBloc(
    StatsState initialState, {
    required this.noteRepository,
    required this.categoryRepository,
  }) : super(initialState);

  @override
  Stream<StatsState> mapEventToState(StatsEvent event) async* {
    if (event is FetchDataEvent) {
      yield const FetchingDataState();
      final notes = await noteRepository.fetchNotesWithCategories();
      final categoryAmount = await categoryRepository.countCategories();
      final notesForCategories = groupBy<NoteWithCategory, Category>(
        notes,
        (noteWithCategory) => noteWithCategory.category,
      ).entries.map((e) => CategoryCount(e.key, e.value.length));
      yield FetchedNotesState(
        notes: notes,
        categoryCountData: notesForCategories.toList(),
        categoryAmount: categoryAmount,
      );
    }
  }
}
