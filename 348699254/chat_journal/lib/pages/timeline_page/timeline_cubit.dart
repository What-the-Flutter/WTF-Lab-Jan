import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/functions.dart';

import '../../data/model/activity_page.dart';
import '../../data/model/event.dart';
import '../../data/repository/event_repository.dart';
import '../../data/repository/page_repository.dart';
import 'timeline_state.dart';

class TimelineCubit extends Cubit<TimelineState> {
  final ActivityPageRepository pageRepository;
  final EventRepository eventRepository;

  TimelineCubit(this.pageRepository, this.eventRepository)
      : super(
          TimelineState(
            timelineList: [],
            pageNameList: [],
            isMarked: false,
            isAllMarked: false,
            isSearching: false,
            searchData: '',
            hashtagList: [],
            isSelectedHashtag: false,
            selectedHashtagList: [],
          ),
        );

  void init(String pageId) {
    showAllEvents();
  }

  void showAllEvents() async {
    final eventList = await eventRepository.fetchEventList();
    final pageList = await pageRepository.fetchActivityPageList();
    final pageNameList = <String>[];
    var pageNameL = <ActivityPage>[];
    eventList.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    for (final event in eventList) {
      pageNameL = pageList.where((page) => page.id == event.pageId).toList();
    }
    print(pageNameL.length);
    for (var i = 0; i < pageNameL.length; i++) {
      pageNameList.add(pageNameL[i].name);
    }
    emit(
      state.copyWith(
        timelineList: eventList,
        pageNameList: pageNameList,
      ),
    );
  }

  void showMarkedEvents(bool isAllMarked) async {
    final markedList = await eventRepository.fetchEventList();
    var sortedMarkedList = <Event>[];
    if (isAllMarked) {
      sortedMarkedList =
          markedList.where((event) => event.isMarked == true).toList();
      sortedMarkedList.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    } else {
      sortedMarkedList = markedList.toList();
      sortedMarkedList.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    }
    emit(
      state.copyWith(
        timelineList: sortedMarkedList,
        isAllMarked: isAllMarked,
      ),
    );
  }

  void markEvent(int index) {
    final markedEvent = state.timelineList[index].copyWith(
      isMarked: !state.timelineList[index].isMarked,
    );
    eventRepository.updateEvent(markedEvent);
    showAllEvents();
  }

  void startSearching() {
    emit(
      state.copyWith(
        isSearching: true,
      ),
    );
  }

  void finishSearching() {
    emit(
      state.copyWith(
        isSearching: false,
        searchData: '',
      ),
    );
  }

  void showFiltersEvents(List result) {
    final pageList = <ActivityPage>[];
    final categoryList = <Event>[];
    final hashtagList = <String>[];
    if (result[0] == 'search') {
      showAllSearchedEvents(result[1]);
    } else if (result[0] == 'page') {
      for (final page in result[1]) {
        pageList.add(page);
      }
      showAllEventsByPages(result[2], pageList);
    } else if (result[0] == 'tag') {
      for (final hashtag in result[1]) {
        hashtagList.add(hashtag);
      }
      showAllEventsByHashtags(hashtagList);
    } else if (result[0] == 'category') {
      for (final category in result[1]) {
        categoryList.add(category);
      }
      showAllEventsByCategories(categoryList);
    } else {
      showAllEvents();
    }
  }

  void showAllSearchedEvents(String text) async {
    var eventList = <Event>[];
    final searchedEvents = await eventRepository.fetchEventList();
    eventList = searchedEvents
        .where((event) => event.eventData.contains(text))
        .toList();
    emit(
      state.copyWith(
        timelineList: eventList,
      ),
    );
  }

  void searchEvent(String text) {
    emit(
      state.copyWith(
        searchData: text,
      ),
    );
  }

  void showAllEventsByCategories(List<Event> selectedEventList) async {
    final eventByCategoriesList = <Event>[];
    final eventList = await eventRepository.fetchEventList();
    for (var i = 0; i < selectedEventList.length; i++) {
      final tempCategoriesList = eventList
          .where((event) =>
              event.categoryName == selectedEventList[i].categoryName)
          .toList();
      eventByCategoriesList.addAll(tempCategoriesList);
    }
    eventByCategoriesList
        .sort((a, b) => b.creationDate.compareTo(a.creationDate));
    emit(
      state.copyWith(
        timelineList: eventByCategoriesList,
      ),
    );
  }

  void showAllEventsByPages(
      bool arePagesIgnored, List<ActivityPage> selectedPageList) async {
    var eventByPagesList = <Event>[];
    final eventList = await eventRepository.fetchEventList();
    arePagesIgnored
        ? eventByPagesList = _ignoredPageList(eventList, selectedPageList)
        : eventByPagesList = _includedPageList(eventList, selectedPageList);
    eventByPagesList.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    emit(
      state.copyWith(
        timelineList: eventByPagesList,
      ),
    );
  }

  List<Event> _ignoredPageList(
      List<Event> eventList, List<ActivityPage> selectedPageList) {
    final eventByPagesList = <Event>[];
    for (var i = 0; i < selectedPageList.length; i++) {
      final tempPagesList = eventList
          .where((event) => !event.pageId.contains(selectedPageList[i].id))
          .toList();
      eventByPagesList.addAll(tempPagesList);
    }
    return eventByPagesList;
  }

  List<Event> _includedPageList(
      List<Event> eventList, List<ActivityPage> selectedPageList) {
    final eventByPagesList = <Event>[];
    for (var i = 0; i < selectedPageList.length; i++) {
      final tempPagesList = eventList
          .where((event) => event.pageId == selectedPageList[i].id)
          .toList();
      eventByPagesList.addAll(tempPagesList);
    }
    return eventByPagesList;
  }

  void showAllEventsByHashtags(List<String> selectedHashtagList) async {
    final eventByHashtagsList = <Event>[];
    final eventList = await eventRepository.fetchEventList();
    for (var i = 0; i < selectedHashtagList.length; i++) {
      final tempHashtagsList = eventList
          .where((event) => event.eventData.contains(selectedHashtagList[i]))
          .toList();
      eventByHashtagsList.addAll(tempHashtagsList);
    }
    eventByHashtagsList
        .sort((a, b) => b.creationDate.compareTo(a.creationDate));
    emit(
      state.copyWith(
        timelineList: eventByHashtagsList,
      ),
    );
  }

  Future<void> hashTagList() async {
    final eventList = await eventRepository.fetchEventList();
    final eventTextList = <String>[];
    for (var event in eventList) {
      eventTextList.add(event.eventData);
    }
    final hashTagList = extractHashTags(eventTextList.toString());
    emit(
      state.copyWith(
        hashtagList: hashTagList,
      ),
    );
  }

  void onHashtagSelected(String hashtag) {
    isHashtagSelected(hashtag)
        ? unselectHashtag(hashtag)
        : selectHashtag(hashtag);
  }

  bool isHashtagSelected(String hashtag) {
    return state.selectedHashtagList.contains(hashtag);
  }

  void selectHashtag(String hashtag) {
    final hashtags = state.selectedHashtagList;
    hashtags.add(hashtag);
    emit(
      state.copyWith(
        selectedHashtagList: hashtags,
      ),
    );
  }

  void unselectHashtag(String hashtag) {
    final hashtags = state.selectedHashtagList;
    hashtags.remove(hashtag);
    emit(
      state.copyWith(
        selectedHashtagList: hashtags,
      ),
    );
  }
}
