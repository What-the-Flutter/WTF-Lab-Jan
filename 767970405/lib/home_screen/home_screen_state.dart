part of 'home_screen_cubit.dart';


class HomeScreenState extends Equatable {
  final List<ModelPage> list;
  HomeScreenState({
    this.list,
  });

  HomeScreenState copyWith({
    final List<ModelPage> list,
  }) {
    return HomeScreenState(
      list: list ?? this.list,
    );
  }

  @override
  List<Object> get props => [list];
}
