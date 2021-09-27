part of 'home_cubit.dart';

@immutable
class HomeState{
  final List<PageCategoryInfo> pages;
  final int selectedIndex;

  HomeState({
    this.pages = const [],
    this.selectedIndex = 0,
  });

  HomeState copyWith({
    List<PageCategoryInfo>? pages,
    int? selectedIndex,
  }) {
    return HomeState(
      pages: pages ?? this.pages,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

}
