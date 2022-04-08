import 'package:flutter_bloc/flutter_bloc.dart';

import '/models/chat_model.dart';
import '/models/event_model.dart';
import '../../data/repository/event_repository.dart';
part 'statistic_screen_state.dart';

class StatisticsCubit extends Cubit<StatisticScreenState> {
  final EventRepository eventRepository;

  StatisticsCubit(this.eventRepository)
      : super(
          StatisticScreenState(
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
          .where((event) => event.chatId == selectedPageList[i].id)
          .toList();
      eventByPagesList.addAll(tempPagesList);
    }
    return eventByPagesList;
  }

  void showTotalListThisYear(List? result) async {
    final eventList = await eventRepository.fetchAllEventList();
    var eventByPagesList = <Event>[];
    var yearEventList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      yearEventList = eventByPagesList
          .where((event) => event.date.year == DateTime.now().year)
          .toList();
    } else {
      yearEventList = eventList
          .where((event) => event.date.year == DateTime.now().year)
          .toList();
    }
    emit(
      state.copyWith(
        summaryTotalList: yearEventList,
      ),
    );
  }

  void showBookmarkListThisYear(List? result) async {
    final eventList = await eventRepository.fetchAllEventList();
    var markedList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = <Chat>[];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      markedList = eventByPagesList
          .where((event) =>
              event.isFavorite == true &&
              event.date.year == DateTime.now().year)
          .toList();
    } else {
      markedList = eventList
          .where((event) =>
              event.isFavorite == true &&
              event.date.year == DateTime.now().year)
          .toList();
    }
    emit(
      state.copyWith(
        summaryBookmarkList: markedList,
      ),
    );
  }

  void showCategoryListThisYear(List? result) async {
    final eventList = await eventRepository.fetchAllEventList();
    var eventByPagesList = <Event>[];
    var categoryList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = <Chat>[];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      categoryList = eventByPagesList
          .where((event) =>
              event.categoryIndex != 0 &&
              event.date.year == DateTime.now().year)
          .toList();
    } else {
      categoryList = eventList
          .where((event) =>
              event.categoryIndex != 0 &&
              event.date.year == DateTime.now().year)
          .toList();
    }
    emit(
      state.copyWith(
        summaryCategoryList: categoryList,
      ),
    );
  }

  void showTotalListToday(List? result) async {
    final eventList = await eventRepository.fetchAllEventList();
    var todayEventList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      todayEventList = eventByPagesList
          .where((event) => event.date.day == DateTime.now().day)
          .toList();
    } else {
      todayEventList = eventList
          .where((event) => event.date.day == DateTime.now().day)
          .toList();
    }
    emit(
      state.copyWith(
        summaryTotalList: todayEventList,
      ),
    );
  }

  void showBookmarkListToday(List? result) async {
    final eventList = await eventRepository.fetchAllEventList();
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
              event.isFavorite == true && event.date.day == DateTime.now().day)
          .toList();
    } else {
      markedList = eventList
          .where((event) =>
              event.isFavorite == true && event.date.day == DateTime.now().day)
          .toList();
    }
    emit(
      state.copyWith(
        summaryBookmarkList: markedList,
      ),
    );
  }

  void showCategoryListToday(List? result) async {
    final eventList = await eventRepository.fetchAllEventList();
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
              event.categoryIndex != 0 && event.date.day == DateTime.now().day)
          .toList();
    } else {
      categoryList = eventList
          .where((event) =>
              event.categoryIndex != 0 && event.date.day == DateTime.now().day)
          .toList();
    }
    emit(
      state.copyWith(
        summaryCategoryList: categoryList,
      ),
    );
  }

  void showTotalListPastMonth(List? result) async {
    final eventList = await eventRepository.fetchAllEventList();
    var todayEventList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      todayEventList = eventByPagesList
          .where((event) => DateTime.now().difference(event.date).inDays <= 30)
          .toList();
    } else {
      todayEventList = eventList
          .where((event) => DateTime.now().difference(event.date).inDays <= 30)
          .toList();
    }
    emit(
      state.copyWith(
        summaryTotalList: todayEventList,
      ),
    );
  }

  void showBookmarkListPastMonth(List? result) async {
    final eventList = await eventRepository.fetchAllEventList();
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
              event.isFavorite == true &&
              DateTime.now().difference(event.date).inDays <= 30)
          .toList();
    } else {
      markedList = eventList
          .where((event) =>
              event.isFavorite == true &&
              DateTime.now().difference(event.date).inDays <= 30)
          .toList();
    }
    emit(
      state.copyWith(
        summaryBookmarkList: markedList,
      ),
    );
  }

  void showCategoryListPastMonth(List? result) async {
    final eventList = await eventRepository.fetchAllEventList();
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
              event.categoryIndex != 0 &&
              DateTime.now().difference(event.date).inDays <= 30)
          .toList();
    } else {
      categoryList = eventList
          .where((event) =>
              event.categoryIndex != 0 &&
              DateTime.now().difference(event.date).inDays <= 30)
          .toList();
    }
    emit(
      state.copyWith(
        summaryCategoryList: categoryList,
      ),
    );
  }

  void showTotalListPastWeek(List? result) async {
    final eventList = await eventRepository.fetchAllEventList();
    var todayEventList = <Event>[];
    var eventByPagesList = <Event>[];
    if (result != null && result.isNotEmpty) {
      final selectedPageList = [];
      for (final page in result) {
        selectedPageList.add(page);
      }
      eventByPagesList = _selectedPageList(eventList, selectedPageList);
      todayEventList = eventByPagesList
          .where((event) => DateTime.now().difference(event.date).inDays <= 7)
          .toList();
    } else {
      todayEventList = eventList
          .where((event) => DateTime.now().difference(event.date).inDays <= 7)
          .toList();
    }
    emit(
      state.copyWith(
        summaryTotalList: todayEventList,
      ),
    );
  }

  void showBookmarkListPastWeek(List? result) async {
    final eventList = await eventRepository.fetchAllEventList();
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
              event.isFavorite == true &&
              DateTime.now().difference(event.date).inDays <= 7)
          .toList();
    } else {
      markedList = eventList
          .where((event) =>
              event.isFavorite == true &&
              DateTime.now().difference(event.date).inDays <= 7)
          .toList();
    }
    emit(
      state.copyWith(
        summaryBookmarkList: markedList,
      ),
    );
  }

  void showCategoryListPastWeek(List? result) async {
    final eventList = await eventRepository.fetchAllEventList();
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
              event.categoryIndex != 0 &&
              DateTime.now().difference(event.date).inDays <= 7)
          .toList();
    } else {
      categoryList = eventList
          .where((event) =>
              event.categoryIndex != 0 &&
              DateTime.now().difference(event.date).inDays <= 7)
          .toList();
    }
    emit(
      state.copyWith(
        summaryCategoryList: categoryList,
      ),
    );
  }
}
