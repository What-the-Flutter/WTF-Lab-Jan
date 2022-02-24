import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/database_provider.dart';
import '../../event.dart';
import '../../note.dart';
import 'states_statistics_page.dart';
import 'statistics.dart';

class CubitStatisticsPage extends Cubit<StatesStatisticsPage> {
  CubitStatisticsPage() : super(const StatesStatisticsPage());

  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void init() async {
    setEventList(await _databaseProvider.fetchFullEventsList());
    setNoteList(await _databaseProvider.dbNotesList());
  }

  void setSelectedPeriod(String selectedPeriod) {
    emit(state.copyWith(selectedPeriod: selectedPeriod));
  }

  void setCount(String countBy, List<Statistics> list) {
    var _count = 0;
    for (var event in list) {
      _count += event.value;
    }
    switch (countBy) {
      case 'Events':
        if (_count != state.countOfEvents) {
          setCountOfEvents(_count);
        }
        break;
      case 'Notes':
        if (_count != state.countOfNotes) {
          setCountOfNotes(_count);
        }
        break;
      case 'BookmarkedEvents':
        if (_count != state.countOfBookmarkedEvents) {
          setCountOfBookmarkedEvents(_count);
        }
        break;
    }
  }

  int countWeekOrMonthNotes(int difference) {
    return state.noteList
        .where((element) =>
            DateFormat().add_yMMMd().parse(element.date).isAfter(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day - difference)) &&
            DateFormat().add_yMMMd().parse(element.date).isBefore(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day - difference + 2)))
        .length;
  }

  int countYearNotes(int difference) {
    return state.noteList
        .where((element) =>
            DateFormat().add_yMMMd().parse(element.date).isAfter(DateTime(
                DateTime.now().year, DateTime.now().month - difference)) &&
            DateFormat().add_yMMMd().parse(element.date).isBefore(DateTime(
                DateTime.now().year, DateTime.now().month - difference + 1)))
        .length;
  }

  int countWeekOrMonthEvents(int difference) {
    return state.eventList
        .where((element) =>
            DateFormat().add_yMMMd().parse(element.date).isAfter(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day - difference)) &&
            DateFormat().add_yMMMd().parse(element.date).isBefore(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day - difference + 2)))
        .length;
  }

  int countYearBookMarksEvents(int difference) {
    return state.eventList
        .where((element) =>
            DateFormat().add_yMMMd().parse(element.date).isAfter(DateTime(
                DateTime.now().year, DateTime.now().month - difference)) &&
            DateFormat().add_yMMMd().parse(element.date).isBefore(DateTime(
                DateTime.now().year, DateTime.now().month - difference + 1)) &&
            element.bookmarkIndex == 1)
        .length;
  }

  int countWeekOrMonthBookMarksEvents(int difference) {
    return state.eventList
        .where((element) =>
            DateFormat().add_yMMMd().parse(element.date).isAfter(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day - difference)) &&
            DateFormat().add_yMMMd().parse(element.date).isBefore(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day - difference + 2)) &&
            element.bookmarkIndex == 1)
        .length;
  }

  int countYearEvents(int difference) {
    return state.eventList
        .where((element) =>
            DateFormat().add_yMMMd().parse(element.date).isAfter(DateTime(
                DateTime.now().year, DateTime.now().month - difference)) &&
            DateFormat().add_yMMMd().parse(element.date).isBefore(DateTime(
                DateTime.now().year, DateTime.now().month - difference + 1)))
        .length;
  }

  List<Statistics> generateList(String listBy, int difference,
      List<Statistics> list, int limit, int count) {
    switch (state.selectedPeriod) {
      case 'Past 30 days':
        var _countsByDate = countWeekOrMonth(listBy, difference + 1);
        count += _countsByDate;
        list.add(Statistics(
            '${DateFormat.d().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - difference))}',
            _countsByDate));
        break;
      case 'Past 7 days':
        var _countsByDate = countWeekOrMonth(listBy, difference + 1);
        count += _countsByDate;
        list.add(Statistics(
            '${DateFormat.MMMd().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - difference))}',
            _countsByDate));
        break;
      case 'Past year':
        var _countsByDate = countYear(listBy, difference + 1);
        count += _countsByDate;
        list.add(Statistics(
            '${DateFormat.MMM().format(DateTime(DateTime.now().year, DateTime.now().month - 1 - difference, DateTime.now().day))}',
            _countsByDate));
        break;
    }
    if (difference != limit) {
      generateList(listBy, difference - 1, list, limit, count);
    }
    return list;
  }

  int countYear(String countBy, int difference) => countBy == 'Events'
      ? countYearEvents(difference)
      : countBy == 'Notes'
          ? countYearNotes(difference)
          : countYearBookMarksEvents(difference);

  int countWeekOrMonth(String countBy, int difference) => countBy == 'Events'
      ? countWeekOrMonthEvents(difference)
      : countBy == 'Notes'
          ? countWeekOrMonthNotes(difference)
          : countWeekOrMonthBookMarksEvents(difference);

  void setEventList(List<Event> eventList) =>
      emit(state.copyWith(eventList: eventList));

  void setNoteList(List<Note> noteList) =>
      emit(state.copyWith(noteList: noteList));

  void setCountOfNotes(int countOfNotes) =>
      emit(state.copyWith(countOfNotes: countOfNotes));

  void setCountOfEvents(int countOfEvents) =>
      emit(state.copyWith(countOfEvents: countOfEvents));

  void setCountOfBookmarkedEvents(int countOfBookmarkedEvents) =>
      emit(state.copyWith(countOfBookmarkedEvents: countOfBookmarkedEvents));
}
