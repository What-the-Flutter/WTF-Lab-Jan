import '../../data/model/activity_page.dart';
import '../../data/model/event.dart';

class FiltersState {
  final List<ActivityPage> pageList;
  final List<Event> categoryList;
  final List<String> hashtagList;
  final bool isSelectedPage;
  final bool isSelectedHashtag;
  final bool isSelectedCategory;
  final bool arePagesIgnored;
  final List selectedPageList;
  final List selectedHashtagList;
  final List selectedCategoryList;
  final bool isSearching;
  final String searchData;

  FiltersState({
    required this.pageList,
    required this.categoryList,
    required this.hashtagList,
    required this.isSelectedPage,
    required this.isSelectedHashtag,
    required this.isSelectedCategory,
    required this.arePagesIgnored,
    required this.selectedPageList,
    required this.selectedHashtagList,
    required this.selectedCategoryList,
    required this.isSearching,
    required this.searchData,
    //required this.selectedIconIndex,
  });

  FiltersState copyWith({
    List<ActivityPage>? pageList,
    List<Event>? categoryList,
    List<String>? hashtagList,
    bool? isSelectedPage,
    bool? isSelectedHashtag,
    bool? isSelectedCategory,
    bool? arePagesIgnored,
    List? selectedPageList,
    List? selectedHashtagList,
    List? selectedCategoryList,
    bool? isSearching,
    String? searchData,
  }) {
    return FiltersState(
      pageList: pageList ?? this.pageList,
      categoryList: categoryList ?? this.categoryList,
      hashtagList: hashtagList ?? this.hashtagList,
      isSelectedPage: isSelectedPage ?? this.isSelectedPage,
      isSelectedHashtag: isSelectedHashtag ?? this.isSelectedHashtag,
      isSelectedCategory: isSelectedCategory ?? this.isSelectedCategory,
      arePagesIgnored: arePagesIgnored ?? this.arePagesIgnored,
      selectedPageList: selectedPageList ?? this.selectedPageList,
      selectedHashtagList: selectedHashtagList ?? this.selectedHashtagList,
      selectedCategoryList: selectedCategoryList ?? this.selectedCategoryList,
      isSearching: isSearching ?? this.isSearching,
      searchData: searchData ?? this.searchData,
    );
  }
}
