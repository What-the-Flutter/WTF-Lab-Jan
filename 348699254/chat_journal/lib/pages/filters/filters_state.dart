import '../../data/model/activity_page.dart';

class FiltersState {
  final List<ActivityPage> pageList;
  final List<String?> categoryNameList;
  final List<int?> categoryIconList;
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
    required this.categoryNameList,
    required this.categoryIconList,
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
  });

  FiltersState copyWith({
    List<ActivityPage>? pageList,
    List<String?>? categoryNameList,
    List<int?>? categoryIconList,
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
      categoryNameList: categoryNameList ?? this.categoryNameList,
      categoryIconList: categoryIconList ?? this.categoryIconList,
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
