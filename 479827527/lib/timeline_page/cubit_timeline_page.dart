import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../event.dart';
import '../utils/database.dart';
import '../utils/shared_preferences_provider.dart';
import 'states_timeline_page.dart';

class CubitTimelinePage extends Cubit<StatesTimelinePage> {
  CubitTimelinePage() : super(StatesTimelinePage());

  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void init() async {
    setEventsList(<Event>[]);
    setSearchState(false);
    setSortedByBookmarksState(false);
    initSharedPreferences();
    setEventsList(await _databaseProvider.fetchFullEventsList());
  }

  void sortEventsByDate() {
    state.eventsList
      ..sort(
        (a, b) {
          final aDate = DateFormat().add_yMMMd().parse(a.date);
          final bDate = DateFormat().add_yMMMd().parse(b.date);
          return bDate.compareTo(aDate);
        },
      );
    setEventsList(state.eventsList);
  }

  void setSortedByBookmarksState(bool isSortedByBookmarks) =>
      emit(state.copyWith(isSortedByBookmarks: isSortedByBookmarks));

  void setTextSearchState(bool isSearch) =>
      emit(state.copyWith(isSearch: isSearch));

  void setSearchState(bool isSearch) =>
      emit(state.copyWith(isSearch: isSearch));

  void setEventsList(List<Event> eventsList) =>
      emit(state.copyWith(eventsList: eventsList));

  void initSharedPreferences() {
    emit(
      state.copyWith(
        isBubbleAlignment: SharedPreferencesProvider().fetchBubbleAlignment(),
        isCenterDateBubble: SharedPreferencesProvider().fetchCenterDateBubble(),
      ),
    );
  }
}
