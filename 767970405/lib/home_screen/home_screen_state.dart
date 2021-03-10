part of 'home_screen_cubit.dart';

class HomeScreenState extends Equatable {
  final int currentIndex;
  final List<ModelPage> list;

  HomeScreenState({
    this.list,
    this.currentIndex,
  });

  HomeScreenState copyWith({
    final List<ModelPage> list,
    final int currentIndex,
  }) {
    return HomeScreenState(
      list: list ?? this.list,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object> get props => [list, currentIndex];
}
