import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../event.dart';
import '../note.dart';
import '../utils/database.dart';
import 'states_statistics_page.dart';

class CubitStatisticsPage extends Cubit<StatesStatisticsPage> {
  CubitStatisticsPage() : super(StatesStatisticsPage());
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void init() async {
    setNotesList(<Note>[]);
    setEventsList(<Event>[]);
    setEventsList(await _databaseProvider.fetchFullEventsList());
    setNotesList(await _databaseProvider.fetchNotesList());
  }

  void setSelectedPeriod(String period) {
    emit(state.copyWith(selectedPeriod: period));
    countStatisticsData();
  }

  void countStatisticsData() {
    var dayDifference = 0;
    var yearDifference = 0;

    switch (state.selectedPeriod) {
      case 'Past 7 days':
        dayDifference = 8;
        yearDifference = 0;
        break;
      case 'Past 30 days':
        dayDifference = 31;
        yearDifference = 0;
        break;
      case 'Past year':
        dayDifference = 0;
        yearDifference = 1;
        break;
    }

    final countOfEvents = state.events
        .where(
          (element) =>
              DateFormat().add_yMMMd().parse(element.date).isAfter(
                    DateTime(
                      DateTime.now().year - yearDifference,
                      DateTime.now().month,
                      DateTime.now().day - dayDifference,
                    ),
                  ) &&
              DateFormat().add_yMMMd().parse(element.date).isBefore(
                    DateTime(
                      DateTime.now().year + yearDifference,
                      DateTime.now().month,
                      DateTime.now().day + 1,
                    ),
                  ),
        )
        .length;

    final countOfNotes = state.notes
        .where(
          (element) =>
              DateFormat().add_yMMMd().parse(element.date).isAfter(
                    DateTime(
                      DateTime.now().year - yearDifference,
                      DateTime.now().month,
                      DateTime.now().day - dayDifference,
                    ),
                  ) &&
              DateFormat().add_yMMMd().parse(element.date).isBefore(
                    DateTime(
                      DateTime.now().year + yearDifference,
                      DateTime.now().month,
                      DateTime.now().day + 1,
                    ),
                  ),
        )
        .length;

    final countOfBookmarkedEvents =
        state.events.where((element) => element.bookmarkIndex == 1).length;

    setCountOfNotes(countOfNotes);
    setCountOfEvents(countOfEvents);
    setCountOfBookmarkedEvents(countOfBookmarkedEvents);
  }

  void setCountOfNotes(int count) =>
      emit(state.copyWith(countOfNotesInPeriod: count));

  void setCountOfEvents(int count) =>
      emit(state.copyWith(countOfEventsInPeriod: count));

  void setCountOfBookmarkedEvents(int count) =>
      emit(state.copyWith(countOfBookmarkedEventsInPeriod: count));

  void setNotesList(List<Note> notes) => emit(state.copyWith(notes: notes));

  void setEventsList(List<Event> events) =>
      emit(state.copyWith(events: events));
}
