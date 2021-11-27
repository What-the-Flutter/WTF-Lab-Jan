part of 'home_cubit.dart';

class HomeState extends Equatable {
  final int index;
  HomeState({
    required this.index,
  });

  @override
  List<Object> get props => [index];
}
