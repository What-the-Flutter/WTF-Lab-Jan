import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../models/event_model.dart';
import '../../models/note_model.dart';
import '../../services/db_provider.dart';

part 'statistics_page_state.dart';

class StatisticsPageCubit extends Cubit<StatisticsPageState> {
  final DBProvider _dbProvider = DBProvider();
  final _today = DateTime.now();

  StatisticsPageCubit()
      : super(
          StatisticsPageState(
            isSelected: false,
            countOfEvents: 0,
            notes: [],
            events: [],
            bookmarks: [],
            period: 'Past 7 days',
          ),
        );

  void init() async {
    emit(
      state.copyWith(
        period: 'Past 7 days',
        isSelected: false,
        notes: await _dbProvider.dbNotesList(),
        events: await _dbProvider.dbAllEventList(),
        bookmarks: await _dbProvider.dbAllBookmarks(),
        countOfEvents: 0,
      ),
    );
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

  void setSelectedPeriod(String value) => emit(state.copyWith(period: value));

  void setSelectedState() =>
      emit(state.copyWith(isSelected: !state.isSelected));
}
