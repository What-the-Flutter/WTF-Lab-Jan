import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/database_access.dart';
import '../../data/preferences_access.dart';
import 'timeline_state.dart';

final _db = DatabaseAccess.instance();

class TimelineCubit extends Cubit<TimelineState> {
  TimelineCubit(TimelineState state) : super(state);

  void initialize() async {
    final prefs = PreferencesAccess();
    emit(state.copyWith(
      events: await _db.fetchAllEvents(),
      isDateCentered: prefs.fetchDateCentered(),
      isRightToLeft: prefs.fetchRightToLeft(),
    ));
  }

  void changeShowingFavourites() =>
      emit(state.copyWith(showingFavourites: !state.showingFavourites));

  void setOnSearch(bool isOnSearch) => emit(state.copyWith(isOnSearch: isOnSearch));

  void setFilter(String text) => emit(state.copyWith(filter: text));
}
