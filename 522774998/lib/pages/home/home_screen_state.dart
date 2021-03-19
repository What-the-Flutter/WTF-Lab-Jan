part of 'home_screen_cubit.dart';

abstract class HomeScreenState {
  final int currentIndex;
  final List<PropertyPage> list;

  HomeScreenState({
    this.list,
    this.currentIndex,
  });

  HomeScreenState copyWith({
    final List<PropertyPage> list,
    final int currentIndex,
  });
}

class HomeScreenStateAwait extends HomeScreenState {
  HomeScreenStateAwait({
    int currentIndex,
  }) : super(
    currentIndex: currentIndex,
  );

  @override
  HomeScreenState copyWith({
    List<PropertyPage> list,
    int currentIndex,
  }) {
    throw UnimplementedError();
  }
}

class HomeScreenStateShow extends HomeScreenState {
  HomeScreenStateShow({
    List<PropertyPage> pages,
    int currentIndex,
  }) : super(
    list: pages,
    currentIndex: currentIndex,
  );

  @override
  HomeScreenState copyWith({
    final List<PropertyPage> list,
    final int currentIndex,
  }) {
    return HomeScreenStateShow(
      pages: list ?? this.list,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
