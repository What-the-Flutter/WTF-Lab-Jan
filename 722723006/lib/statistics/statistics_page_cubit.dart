import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../data/db_provider.dart';
import '../event_page/event.dart';
import '../note_page/note.dart';
import 'statistics_page_states.dart';

class StatisticsPageCubit extends Cubit<StatisticsPageStates> {
  StatisticsPageCubit() : super(StatisticsPageStates());
  final DBProvider _dbProvider = DBProvider();
  final _today = DateTime.now();

  void init() {
    emit(state.copyWith(
      period: 'Past 7 days',
      isSelected: false,
      notes: <Note>[],
      events: <Event>[],
      bookmarks: <bool>[],
      countOfEvents: 0,
    ));
    initFromDb();
  }

  void countEvents(int dayDifference, int yearDifference) {
    final countOfEvents = state.events
        .where((element) =>
            DateFormat().add_yMMMd().parse(element.date).isAfter(DateTime(
                  _today.year - yearDifference,
                  _today.month,
                  _today.day - dayDifference,
                )) &&
            DateFormat().add_yMMMd().parse(element.date).isBefore(DateTime(
                  _today.year + yearDifference,
                  _today.month,
                  _today.day + 1,
                )))
        .length;
    emit(state.copyWith(countOfEvents: countOfEvents));
  }

  void initFromDb() async {
    emit(
      state.copyWith(
          notes: await _dbProvider.dbNotesList(),
          events: await _dbProvider.dbAllEventList(),
          bookmarks: await _dbProvider.dbAllBookmarks()),
    );
  }

  void setSelectedPeriod(String value) => emit(state.copyWith(period: value));

  void setSelectedState() =>
      emit(state.copyWith(isSelected: !state.isSelected));
}
