import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/functions.dart';

import '../../data/model/activity_page.dart';
import '../../data/model/event.dart';
import '../../data/repository/event_repository.dart';
import '../../data/repository/page_repository.dart';
import 'filters_state.dart';

class FiltersCubit extends Cubit<FiltersState> {
  final ActivityPageRepository pageRepository;
  final EventRepository eventRepository;

  FiltersCubit(this.pageRepository, this.eventRepository)
      : super(
          FiltersState(
            pageList: [],
            //categoryList: [],
            categoryNameList: [],
            categoryIconList: [],
            hashtagList: [],
            isSelectedPage: false,
            isSelectedHashtag: false,
            isSelectedCategory: false,
            arePagesIgnored: false,
            selectedPageList: [],
            selectedHashtagList: [],
            selectedCategoryList: [],
            isSearching: false,
            searchData: '',
          ),
        );

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

  void searchEvent(String text) {
    emit(
      state.copyWith(
        searchData: text,
      ),
    );
  }

  void showActivityPages() async {
    final pageList = await pageRepository.fetchActivityPageList();
    pageList.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    emit(
      state.copyWith(
        pageList: pageList,
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
        hashtagList: hashTagList.toSet().toList(),
      ),
    );
  }

  void showCategoryList() async {
    var categoryList = <Event>[];
    final eventList = await eventRepository.fetchEventList();
    categoryList =
        eventList.where((event) => event.categoryName!.isNotEmpty).toList();
    final categoryNameList =
        categoryList.map((event) => event.categoryName).toSet().toList();
    final categoryIconList =
        categoryList.map((event) => event.categoryIcon).toSet().toList();
    emit(
      state.copyWith(
        categoryNameList: categoryNameList,
        categoryIconList: categoryIconList,
      ),
    );
  }

  void arePagesIgnored() {
    emit(
      state.copyWith(
        arePagesIgnored: !state.arePagesIgnored,
      ),
    );
  }

  void onPageSelected(ActivityPage page) {
    isPageSelected(page) ? unselectPage(page) : selectPage(page);
  }

  bool isPageSelected(ActivityPage page) {
    return state.selectedPageList.contains(page);
  }

  void selectPage(ActivityPage page) {
    final pages = state.selectedPageList;
    pages.add(page);
    emit(
      state.copyWith(
        selectedPageList: pages,
      ),
    );
  }

  void unselectPage(ActivityPage page) {
    final pages = state.selectedPageList;
    pages.remove(page);
    emit(
      state.copyWith(
        selectedPageList: pages,
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

  void onCategorySelected(String event) {
    isCategorySelected(event) ? unselectCategory(event) : selectCategory(event);
  }

  bool isCategorySelected(String event) {
    return state.selectedCategoryList.contains(event);
  }

  void selectCategory(String event) {
    final events = state.selectedCategoryList;
    events.add(event);
    emit(
      state.copyWith(
        selectedCategoryList: events,
      ),
    );
  }

  void unselectCategory(String event) {
    final events = state.selectedCategoryList;
    events.remove(event);
    emit(
      state.copyWith(
        selectedCategoryList: events,
      ),
    );
  }

  void clearAllSelectedLists() {
    emit(
      state.copyWith(
        selectedPageList: [],
        selectedHashtagList: [],
        selectedCategoryList: [],
      ),
    );
  }
}
