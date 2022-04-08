part of 'statistic_filter_screen_cubit.dart';

class StatisticsFilterScreenState {
  final List<Chat> pageList;
  final bool isSelectedPage;
  final bool arePagesIgnored;
  final List selectedPageList;

  StatisticsFilterScreenState({
    required this.pageList,
    required this.isSelectedPage,
    required this.arePagesIgnored,
    required this.selectedPageList,
  });

  StatisticsFilterScreenState copyWith({
    List<Chat>? pageList,
    bool? isSelectedPage,
    bool? arePagesIgnored,
    List? selectedPageList,
  }) {
    return StatisticsFilterScreenState(
      pageList: pageList ?? this.pageList,
      isSelectedPage: isSelectedPage ?? this.isSelectedPage,
      arePagesIgnored: arePagesIgnored ?? this.arePagesIgnored,
      selectedPageList: selectedPageList ?? this.selectedPageList,
    );
  }
}
