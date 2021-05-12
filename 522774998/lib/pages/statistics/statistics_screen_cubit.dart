import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../repository/messages_repository.dart';
import '../../repository/pages_repository.dart';
import 'statistics_screen_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final MessagesRepository messagesRepository;
  final PagesRepository pagesRepository;
  DateTime today = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0);

  StatisticsCubit(
    StatisticsState state,
    this.messagesRepository,
    this.pagesRepository,
  ) : super(state);

  void initialize() async {
    emit(
      state.copyWith(
        messages: await messagesRepository.messagesFromAllPages(),
        pages: await pagesRepository.pagesList(),
      ),
    );
  }

  void setTimeline(String timeline) {
    emit(
      state.copyWith(timeline: timeline),
    );
  }

  int countPagesDay() {
    final today = DateTime.now();
    final i = state.pages
        .where((element) => element.creationTime
            .isAfter(DateTime(today.year, today.month, today.day)))
        .length;
    return i;
  }

  int countMessagesDay() {
    final today = DateTime.now();
    return state.messages
        .where((element) =>
            element.time.isAfter(DateTime(today.year, today.month, today.day)))
        .length;
  }

  int countBookmarksDay() {
    final today = DateTime.now();
    return state.messages
        .where((element) => (element.time
                .isAfter(DateTime(today.year, today.month, today.day)) &&
            element.isBookmark))
        .length;
  }

  int countTotalDay() {
    return countMessagesDay() + countPagesDay() + countBookmarksDay();
  }

  int countPages(int daysAgo, int monthsAgo) {
    final today = DateTime.now();
    print(DateTime(today.year, today.month - monthsAgo, today.day - daysAgo));
    print(DateTime(today.year, today.month, today.day));
    return state.pages
        .where(
          (element) => (element.creationTime.isAfter(DateTime(
                  today.year, today.month - monthsAgo, today.day - daysAgo)) &&
              element.creationTime
                  .isBefore(DateTime(today.year, today.month, today.day))),
        )
        .length;
  }

  int countMessages(int daysAgo, int monthsAgo) {
    final today = DateTime.now();
    return state.messages
        .where(
          (element) => (element.time.isAfter(DateTime(
                  today.year, today.month - monthsAgo, today.day - daysAgo)) &&
              element.time
                  .isBefore(DateTime(today.year, today.month, today.day))),
        )
        .length;
  }

  int countBookmarks(int daysAgo, int monthsAgo) {
    final today = DateTime.now();
    return state.messages
        .where((element) => (element.time.isAfter(DateTime(
                today.year, today.month - monthsAgo, today.day - daysAgo)) &&
            element.isBookmark &&
            element.time
                .isBefore(DateTime(today.year, today.month, today.day))))
        .length;
  }

  int countTotal(int daysAgo, int monthsAgo) {
    return countMessages(daysAgo, monthsAgo) +
        countPages(daysAgo, monthsAgo) +
        countBookmarks(daysAgo, monthsAgo);
  }

  List<Statistics> generateHoursStatistics(
      int start, int end, Function(int) func) {
    final list = <Statistics>[];
    for (var i = start; i <= end; i++) {
      list.add(Statistics('$i', func(i)));
    }
    return list;
  }

  List<Statistics> generateDaysStatistics(
      int start, int end, Function(int) func) {
    final list = <Statistics>[];
    for (var i = end; i >= start; i--) {
      list.add(Statistics(
          DateFormat('EEEE')
              .format(DateTime.now().subtract(Duration(days: i)))
              .substring(0, 3),
          func(i)));
    }
    return list;
  }

  List<Statistics> generateMonthStatistics(
      int start, int end, Function(int) func) {
    final list = <Statistics>[];
    for (var i = end; i >= start; i--) {
      list.add(Statistics(
          DateFormat('d').format(DateTime.now().subtract(Duration(days: i))),
          func(i)));
    }
    return list;
  }

  List<Statistics> generateYearStatistics(
      int start, int end, Function(int) func) {
    final list = <Statistics>[];
    final today = DateTime.now();
    DateTime date;
    for (var i = start - 1; i >= end - 1; i--) {
      date = today;
      date = DateTime(date.year, date.month - i, date.day, 0, 0);
      list.add(Statistics(
          DateFormat('MMM').format(date).substring(0, 3), func(i + 1)));
      print('DATE $date');
    }
    return list;
  }

  int countPagesHours(int start) => state.pages
      .where((element) =>
          (element.creationTime.isAfter(
              DateTime(today.year, today.month, today.day, start, 0))) &&
          element.creationTime.isBefore(
              DateTime(today.year, today.month, today.day, start + 1, 0)))
      .length;

  int countMessagesHours(int start) => state.messages
      .where((element) =>
          (element.time.isAfter(
              DateTime(today.year, today.month, today.day, start, 0))) &&
          element.time.isBefore(
              DateTime(today.year, today.month, today.day, start + 1, 0)))
      .length;

  int countBookmarksHours(int start) => state.messages
      .where((element) =>
          (element.isBookmark &&
              element.time.isAfter(
                  DateTime(today.year, today.month, today.day, start, 0))) &&
          element.time.isBefore(
              DateTime(today.year, today.month, today.day, start + 1, 0)))
      .length;

  int countTotalHours(int start) =>
      countBookmarksHours(start) +
      countMessagesHours(start) +
      countPagesHours(start);

  int countPagesForDays(int daysAgo) => state.pages
      .where((element) =>
          (element.creationTime.isAfter(
              DateTime(today.year, today.month, today.day - daysAgo, 0, 0))) &&
          element.creationTime.isBefore(
              DateTime(today.year, today.month, today.day - daysAgo + 1, 0, 0)))
      .length;

  int countMessagesForDays(int daysAgo) => state.messages
      .where((element) =>
          (element.time.isAfter(
              DateTime(today.year, today.month, today.day - daysAgo, 0, 0))) &&
          element.time.isBefore(
              DateTime(today.year, today.month, today.day - daysAgo + 1, 0, 0)))
      .length;

  int countBookmarksForDays(int daysAgo) => state.messages
      .where((element) =>
          (element.isBookmark &&
              element.time.isAfter(DateTime(
                  today.year, today.month, today.day - daysAgo, 0, 0))) &&
          element.time.isBefore(
              DateTime(today.year, today.month, today.day - daysAgo + 1, 0, 0)))
      .length;

  int countTotalForDays(int daysAgo) =>
      countBookmarksForDays(daysAgo) +
      countMessagesForDays(daysAgo) +
      countPagesForDays(daysAgo);

  int countPagesForMonths(int monthsAgo) => state.pages
      .where((element) =>
          (element.creationTime.isAfter(DateTime(
              today.year, today.month - monthsAgo, today.day, 0, 0))) &&
          element.creationTime.isBefore(DateTime(
              today.year, today.month - monthsAgo + 1, today.day, 0, 0)))
      .length;

  int countMessagesForMonths(int monthsAgo) => state.messages
      .where((element) =>
          (element.time.isAfter(DateTime(
              today.year, today.month - monthsAgo, today.day, 0, 0))) &&
          element.time.isBefore(DateTime(
              today.year, today.month - monthsAgo + 1, today.day, 0, 0)))
      .length;

  int countBookmarksForMonths(int monthsAgo) => state.messages
      .where((element) =>
          (element.isBookmark &&
              element.time.isAfter(DateTime(
                  today.year, today.month - monthsAgo, today.day, 0, 0))) &&
          element.time.isBefore(DateTime(
              today.year, today.month - monthsAgo + 1, today.day, 0, 0)))
      .length;

  int countTotalForMonths(int monthsAgo) =>
      countBookmarksForMonths(monthsAgo) +
      countMessagesForMonths(monthsAgo) +
      countPagesForMonths(monthsAgo);
}

class Statistics {
  final String text;
  final int value;

  Statistics(
    this.text,
    this.value,
  );
}
