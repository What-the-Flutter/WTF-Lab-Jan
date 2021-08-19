import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/category.dart';
import '../../../../../models/tag.dart';
import '../../../../../repository/category_repository.dart';
import '../../../../../repository/note_repository.dart';
import 'filter_event.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final CategoryRepository categoryRepository;
  final NoteRepository noteRepository;

  FilterBloc(
    FilterState initialState, {
    required this.categoryRepository,
    required this.noteRepository,
  }) : super(initialState);

  @override
  Stream<FilterState> mapEventToState(FilterEvent event) async* {
    if (event is FetchDataEvent) {
      yield const FetchingDataState();
      yield await _fetchNotes();
    } else if (state is FetchedDataState) {
      final currentState = state as FetchedDataState;
      if (event is SelectTagEvent) {
        final list = List<Tag>.from(currentState.selectedTags);
        currentState.selectedTags.contains(event.tag)
            ? list.remove(event.tag)
            : list.add(event.tag);
        yield currentState.copyWith(selectedTags: list);
      } else if (event is SelectCategoryEvent) {
        final list = List<Category>.from(currentState.selectedCategories);
        currentState.selectedCategories.contains(event.category)
            ? list.remove(event.category)
            : list.add(event.category);
        yield currentState.copyWith(selectedCategories: list);
      } else if (event is ResetFilter) {
        yield currentState.copyWith(query: '', selectedCategories: [], selectedTags: []);
      } else if (event is QueryChangedEvent) {
        yield currentState.copyWith(query: event.query);
      } else if (event is ClearQueryEvent) {
        yield currentState.copyWith(query: '');
      }
    }
  }

  Future<FilterState> _fetchNotes() async {
    final categories = await categoryRepository.fetchCategories();
    final tags = await noteRepository.fetchTags();
    return FetchedDataState(tags: tags, categories: categories);
  }
}
