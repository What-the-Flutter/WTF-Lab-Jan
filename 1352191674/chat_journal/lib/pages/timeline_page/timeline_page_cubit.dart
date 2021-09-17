import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/event_model.dart';
import '../../services/db_provider.dart';
import '../../services/shared_preferences_provider.dart';

part 'timeline_page_state.dart';

class TimelinePageCubit extends Cubit<TimelinePageState> {
  final SharedPreferencesProvider _prefs = SharedPreferencesProvider();
  final DBProvider _db = DBProvider();

  TimelinePageCubit()
      : super(
          TimelinePageState(
            isIconButtonSearchPressed: false,
            isCenterDateBubble: false,
            searchText: '',
            isWriting: false,
            isEditing: false,
            isAllBookmarked: false,
            allEventList: [],
            isSearchButtonPressed: false,
          ),
        );

  void init() async {
    emit(
      state.copyWith(
        allEventList: await _db.dbAllEventList(),
        isEditing: false,
        isWriting: false,
        isAllBookmarked: false,
        isIconButtonSearchPressed: false,
        isCenterDateBubble: _prefs.fetchBubbleAlignment(),
      ),
    );
  }

  void updateList() =>
      emit(state.copyWith(isCenterDateBubble: state.isCenterDateBubble));

  void setEditing() => emit(state.copyWith(isEditing: !state.isEditing));

  void setIconButtonSearch() => emit(state.copyWith(
      isIconButtonSearchPressed: !state.isIconButtonSearchPressed));

  void deleteEvent(Event event) {
    _db.deleteEvent(event);
    final eventList = state.allEventList;
    eventList.remove(event);
    emit(state.copyWith(allEventList: eventList));
  }

  void setAllBookmarked() =>
      emit(state.copyWith(isAllBookmarked: !state.isAllBookmarked));

  void setWriting(bool isWriting) =>
      emit(state.copyWith(isWriting: isWriting));

  void setSearchText(String searchText) =>
      emit(state.copyWith(searchText: searchText));
}
