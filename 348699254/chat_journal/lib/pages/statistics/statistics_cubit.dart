import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/activity_page.dart';
import '../../data/model/event.dart';
import '../../data/repository/event_repository.dart';
import '../constants.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  //final ActivityPageRepository pageRepository;
  final EventRepository eventRepository;

  StatisticsCubit(this.eventRepository)
      : super(
          StatisticsState(
            summaryTotalList: [],
            summaryBookmarkList: [],
            summaryCategoryList: [],
            timePeriod: 'Past 30 days',
          ),
        );

  void selectTimePeriod(String timePeriod) {
    emit(
      state.copyWith(
        timePeriod: timePeriod,
      ),
    );
  }

  List<Event> _selectedPageList(
    List<Event> eventList,
    List selectedPageList,
  ) {
    final eventByPagesList = <Event>[];
    for (var i = 0; i < selectedPageList.length; i++) {
      final tempPagesList = eventList
          .where((event) => event.pageId == selectedPageList[i].id)
          .toList();
      eventByPagesList.addAll(tempPagesList);
    }
    return eventByPagesList;
  }

  void showTotalListThisYear(List? result) async {
    final eventList = await eventRepository.fetchEventList();
    var eventByPagesList = <Event>[];
    var yearEventList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      yearEventList = eventByPagesList
          .where((event) => event.creationDate.year == DateTime.now().year)
          .toList();
    } else {
      yearEventList = eventList
          .where((event) => event.creationDate.year == DateTime.now().year)
          .toList();
    }
    emit(
      state.copyWith(
        summaryTotalList: yearEventList,
      ),
    );
  }

  void showBookmarkListThisYear(List? result) async {
    final eventList = await eventRepository.fetchEventList();
    var markedList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = <ActivityPage>[];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      markedList = eventByPagesList
          .where((event) =>
              event.isMarked == true &&
              event.creationDate.year == DateTime.now().year)
          .toList();
    } else {
      markedList = eventList
          .where((event) =>
              event.isMarked == true &&
              event.creationDate.year == DateTime.now().year)
          .toList();
    }
    emit(
      state.copyWith(
        summaryBookmarkList: markedList,
      ),
    );
  }

  void showCategoryListThisYear(List? result) async {
    final eventList = await eventRepository.fetchEventList();
    var eventByPagesList = <Event>[];
    var categoryList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = <ActivityPage>[];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      categoryList = eventByPagesList
          .where((event) =>
              event.categoryName!.isNotEmpty &&
              event.creationDate.year == DateTime.now().year)
          .toList();
    } else {
      categoryList = eventList
          .where((event) =>
              event.categoryName!.isNotEmpty &&
              event.creationDate.year == DateTime.now().year)
          .toList();
    }
    emit(
      state.copyWith(
        summaryCategoryList: categoryList,
      ),
    );
  }

  void showTotalListToday(List? result) async {
    final eventList = await eventRepository.fetchEventList();
    var todayEventList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      todayEventList = eventByPagesList
          .where((event) => event.creationDate.day == DateTime.now().day)
          .toList();
    } else {
      todayEventList = eventList
          .where((event) => event.creationDate.day == DateTime.now().day)
          .toList();
    }
    emit(
      state.copyWith(
        summaryTotalList: todayEventList,
      ),
    );
  }

  void showBookmarkListToday(List? result) async {
    final eventList = await eventRepository.fetchEventList();
    var markedList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      markedList = eventByPagesList
          .where((event) =>
              event.isMarked == true &&
              event.creationDate.day == DateTime.now().day)
          .toList();
    } else {
      markedList = eventList
          .where((event) =>
              event.isMarked == true &&
              event.creationDate.day == DateTime.now().day)
          .toList();
    }
    emit(
      state.copyWith(
        summaryBookmarkList: markedList,
      ),
    );
  }

  void showCategoryListToday(List? result) async {
    final eventList = await eventRepository.fetchEventList();
    var categoryList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      categoryList = eventByPagesList
          .where((event) =>
              event.categoryName!.isNotEmpty &&
              event.creationDate.day == DateTime.now().day)
          .toList();
    } else {
      categoryList = eventList
          .where((event) =>
              event.categoryName!.isNotEmpty &&
              event.creationDate.day == DateTime.now().day)
          .toList();
    }
    emit(
      state.copyWith(
        summaryCategoryList: categoryList,
      ),
    );
  }

  void showTotalListPastMonth(List? result) async {
    final eventList = await eventRepository.fetchEventList();
    var todayEventList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      todayEventList = eventByPagesList
          .where((event) =>
              DateTime.now().difference(event.creationDate).inDays <=
              daysInMonth)
          .toList();
    } else {
      todayEventList = eventList
          .where((event) =>
              DateTime.now().difference(event.creationDate).inDays <=
              daysInMonth)
          .toList();
    }
    emit(
      state.copyWith(
        summaryTotalList: todayEventList,
      ),
    );
  }

  void showBookmarkListPastMonth(List? result) async {
    final eventList = await eventRepository.fetchEventList();
    var markedList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      markedList = eventByPagesList
          .where((event) =>
              event.isMarked == true &&
              DateTime.now().difference(event.creationDate).inDays <=
                  daysInMonth)
          .toList();
    } else {
      markedList = eventList
          .where((event) =>
              event.isMarked == true &&
              DateTime.now().difference(event.creationDate).inDays <=
                  daysInMonth)
          .toList();
    }
    emit(
      state.copyWith(
        summaryBookmarkList: markedList,
      ),
    );
  }

  void showCategoryListPastMonth(List? result) async {
    final eventList = await eventRepository.fetchEventList();
    var categoryList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      categoryList = eventByPagesList
          .where((event) =>
              event.categoryName!.isNotEmpty &&
              DateTime.now().difference(event.creationDate).inDays <=
                  daysInMonth)
          .toList();
    } else {
      categoryList = eventList
          .where((event) =>
              event.categoryName!.isNotEmpty &&
              DateTime.now().difference(event.creationDate).inDays <=
                  daysInMonth)
          .toList();
    }
    emit(
      state.copyWith(
        summaryCategoryList: categoryList,
      ),
    );
  }

  void showTotalListPastWeek(List? result) async {
    final eventList = await eventRepository.fetchEventList();
    var todayEventList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      todayEventList = eventByPagesList
          .where((event) =>
              DateTime.now().difference(event.creationDate).inDays <=
              daysInWeek)
          .toList();
    } else {
      todayEventList = eventList
          .where((event) =>
              DateTime.now().difference(event.creationDate).inDays <=
              daysInWeek)
          .toList();
    }
    emit(
      state.copyWith(
        summaryTotalList: todayEventList,
      ),
    );
  }

  void showBookmarkListPastWeek(List? result) async {
    final eventList = await eventRepository.fetchEventList();
    var markedList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      markedList = eventByPagesList
          .where((event) =>
              event.isMarked == true &&
              DateTime.now().difference(event.creationDate).inDays <=
                  daysInWeek)
          .toList();
    } else {
      markedList = eventList
          .where((event) =>
              event.isMarked == true &&
              DateTime.now().difference(event.creationDate).inDays <=
                  daysInWeek)
          .toList();
    }
    emit(
      state.copyWith(
        summaryBookmarkList: markedList,
      ),
    );
  }

  void showCategoryListPastWeek(List? result) async {
    final eventList = await eventRepository.fetchEventList();
    var categoryList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      categoryList = eventByPagesList
          .where((event) =>
              event.categoryName!.isNotEmpty &&
              DateTime.now().difference(event.creationDate).inDays <=
                  daysInWeek)
          .toList();
    } else {
      categoryList = eventList
          .where((event) =>
              event.categoryName!.isNotEmpty &&
              DateTime.now().difference(event.creationDate).inDays <=
                  daysInWeek)
          .toList();
    }
    emit(
      state.copyWith(
        summaryCategoryList: categoryList,
      ),
    );
  }
}
