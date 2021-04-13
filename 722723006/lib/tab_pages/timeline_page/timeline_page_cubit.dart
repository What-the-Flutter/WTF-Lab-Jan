import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/db_provider.dart';
import '../../data/shared_preferences_provider.dart';
import '../../event_page/event.dart';

import 'timeline_page_states.dart';

class TimelinePageCubit extends Cubit<TimelinePageStates> {
  TimelinePageCubit() : super(TimelinePageStates());
  final DBProvider _dbProvider = DBProvider();
  final SharedPreferencesProvider _prefs = SharedPreferencesProvider();

  void init() {
    emit(
      state.copyWith(
        isEditing: false,
        isWriting: false,
        isAllBookmarked: false,
        isIconButtonSearchPressed: false,
      ),
    );
    initEventList();
  }

  void initEventList() async {
    emit(state.copyWith(
        isCenterDateBubble: _prefs.fetchCenterDateBubbleState()));
    emit(state.copyWith(eventList: await _dbProvider.dbAllEventList()));
  }

  void setEditingState() => emit(state.copyWith(isEditing: !state.isEditing));

  void setIconButtonSearchState() => emit(state.copyWith(
      isIconButtonSearchPressed: !state.isIconButtonSearchPressed));

  void deleteEvent(Event event) {
    _dbProvider.deleteEvent(event);
    state.eventList.remove(event);
    emit(state.copyWith(eventList: state.eventList));
  }

  void setAllBookmarkedState() =>
      emit(state.copyWith(isAllBookmarked: !state.isAllBookmarked));

  void setWritingState(bool isWriting) =>
      emit(state.copyWith(isWriting: isWriting));

  void setSearchText(String searchText) =>
      emit(state.copyWith(searchText: searchText));
}
