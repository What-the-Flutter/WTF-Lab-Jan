part of 'home_cubit.dart';

enum HomeMethod { initial,show, pin, edit, add, delete, unPin }

abstract class HomeState extends Equatable {
  final List<Category> categoryList;
  final HomeMethod method;

  const HomeState(this.categoryList, this.method);

  @override
  List<Object> get props => [categoryList, method];
}

class HomeAwaitInitial extends HomeState {
  HomeAwaitInitial() : super([], HomeMethod.initial);
}

class HomeShow extends HomeState {
  HomeShow(
    List<Category> categoryList,
    HomeMethod method,
  ) : super(
          categoryList,
          method,
        );
}
