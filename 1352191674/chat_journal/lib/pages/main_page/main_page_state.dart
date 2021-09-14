part of 'main_page_cubit.dart';

class MainState {
  final Widget? currentPage;
  final int currentIndex;

  MainState({
    this.currentPage,
    required this.currentIndex,
  });

  MainState copyWith({
    Widget? currentPage,
    int? currentIndex,
    bool? isSearched,
  }) {
    return MainState(
      currentPage: currentPage ?? this.currentPage,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

}
