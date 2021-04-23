part of 'home_screen_cubit.dart';

class HomeScreenState {
  final bool isLoad;
  final int currentIndex;
  final List<ModelPage> pages;

  HomeScreenState({
    this.isLoad,
    this.pages,
    this.currentIndex,
  });

  HomeScreenState copyWith({
    final bool isLoad,
    final List<ModelPage> pages,
    final int currentIndex,
  }) {
    return HomeScreenState(
      isLoad: isLoad ?? this.isLoad,
      pages: pages ?? this.pages,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
