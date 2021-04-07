part of 'home_screen_cubit.dart';

abstract class HomeScreenState extends Equatable {
  final int currentIndex;
  final List<ModelPage> list;

  HomeScreenState({
    this.list,
    this.currentIndex,
  });

  HomeScreenState copyWith({
    final List<ModelPage> list,
    final int currentIndex,
  });

  @override
  List<Object> get props => [list, currentIndex];
}

class HomeScreenAwait extends HomeScreenState {
  HomeScreenAwait({
    int currentIndex,
  }) : super(
    currentIndex: currentIndex,
  );

  @override
  List<Object> get props => [list, currentIndex];

  @override
  HomeScreenState copyWith({
    List<ModelPage> list,
    int currentIndex,
  }) {
    throw UnimplementedError();
  }
}

class HomeScreenShow extends HomeScreenState {
  HomeScreenShow({
    List<ModelPage> pages,
    int currentIndex,
  }) : super(
    list: pages,
    currentIndex: currentIndex,
  );

  @override
  HomeScreenState copyWith({
    final List<ModelPage> list,
    final int currentIndex,
  }) {
    return HomeScreenShow(
      pages: list ?? this.list,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
