part of 'home_cubit.dart';

enum HomeMethod { initial, pin, edit, add, delete, unPin }

abstract class HomeState extends Equatable {
  final List<Category> categoryList;
  final HomeMethod method;

  const HomeState(this.categoryList, this.method);

  @override
  List<Object> get props => [categoryList, method];
}

class HomeInitial extends HomeState {
  HomeInitial(
    List<Category> categoryList,
  ) : super(
          categoryList,
          HomeMethod.initial,
        );
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
