import 'package:flutter_bloc/flutter_bloc.dart';

import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(SearchState initialState) : super(initialState);

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is InitStateEvent) {
      yield SearchState(notes: event.notes, tags: event.tags);
    } else if (event is TagTapEvent) {
      yield state.copyWith(selectedTag: state.selectedTag == event.tag ? null : event.tag);
    }
  }
}
