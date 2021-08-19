import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/note.dart';
import '../../../../../models/tag.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(SearchState initialState) : super(initialState);

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is InitStateEvent) {
      yield SearchState(notes: event.notes, tags: event.tags);
    } else if (event is TagTapEvent) {
      yield _tagTap(event);
    } else if (event is QueryChangedEvent) {
      yield _queryChanged(event);
    }
  }

  SearchState _tagTap(TagTapEvent event) {
    final list = List<Tag>.from(state.selectedTags);
    state.selectedTags.contains(event.tag) ? list.remove(event.tag) : list.add(event.tag);
    final filteredList = _filterWith(list, state.query);
    return state.copyWith(selectedTags: list, filteredNotes: filteredList);
  }

  SearchState _queryChanged(QueryChangedEvent event) {
    final filteredList = _filterWith(state.selectedTags, event.query);
    return state.copyWith(query: event.query, filteredNotes: filteredList);
  }

  List<Note> _filterWith(List<Tag> tags, String query) {
    return state.notes
        .where(
          (note) =>
              (note.text?.contains(query) ?? false) &&
              (tags.isNotEmpty ? tags.any((tag) => note.text?.contains(tag.name) ?? false) : true),
        )
        .toList();
  }
}
