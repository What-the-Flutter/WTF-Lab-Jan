import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/database_provider.dart';
import '../../data/shared_preferences_provider.dart';
import '../../event.dart';
import 'states_timeline_page.dart';

class CubitTimelinePage extends Cubit<StatesTimelinePage> {
  CubitTimelinePage() : super(const StatesTimelinePage());

  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void init() async {
    setIsSearch(false);
    setSortedByBookmarksState(false);
    initSharedPreferences();
    setEventList(await _databaseProvider.fetchFullEventsList());
    sortEventsByDate();
  }

  void updateBookmark(int index) {
    state.eventList[index].bookmarkIndex == 0
        ? state.eventList[index].bookmarkIndex = 1
        : state.eventList[index].bookmarkIndex = 0;
    setEventList(state.eventList);
    _databaseProvider.updateEvent(state.eventList[index]);
  }

  void sortEventsByDate() {
    state.eventList.sort(
      (a, b) {
        final aDate = DateFormat().add_yMMMd().parse(a.date);
        final bDate = DateFormat().add_yMMMd().parse(b.date);
        return bDate.compareTo(aDate);
      },
    );
    setEventList(state.eventList);
  }

  void setSortedByBookmarksState(bool isSortedByBookmarks) =>
      emit(state.copyWith(isSortedByBookmarks: isSortedByBookmarks));

  void setIsSearch(bool isSearch) => emit(state.copyWith(isSearch: isSearch));

  void setEventList(List<Event> eventList) =>
      emit(state.copyWith(eventList: eventList));

  void initSharedPreferences() {
    emit(
      state.copyWith(
        isBubbleAlignment: SharedPreferencesProvider().fetchBubbleAlignment(),
        isCenterDateBubble: SharedPreferencesProvider().fetchCenterDateBubble(),
      ),
    );
  }
}
