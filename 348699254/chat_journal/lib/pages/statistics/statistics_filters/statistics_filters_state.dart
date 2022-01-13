import '../../../data/model/activity_page.dart';

class StatisticsFiltersState {
  final List<ActivityPage> pageList;
  final bool isSelectedPage;
  final bool arePagesIgnored;
  final List selectedPageList;

  StatisticsFiltersState({
    required this.pageList,
    required this.isSelectedPage,
    required this.arePagesIgnored,
    required this.selectedPageList,
  });

  StatisticsFiltersState copyWith({
    List<ActivityPage>? pageList,
    bool? isSelectedPage,
    bool? arePagesIgnored,
    List? selectedPageList,
  }) {
    return StatisticsFiltersState(
      pageList: pageList ?? this.pageList,
      isSelectedPage: isSelectedPage ?? this.isSelectedPage,
      arePagesIgnored: arePagesIgnored ?? this.arePagesIgnored,
      selectedPageList: selectedPageList ?? this.selectedPageList,
    );
  }
}
