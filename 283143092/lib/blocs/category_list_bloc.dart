import 'package:bloc/bloc.dart';
import '../models/category.dart';

class CategoryListBloc extends Cubit<List> {
  CategoryListBloc(List<Category> initialState) : super(initialState);

  void _setState() => emit(state);

  void add(Category category) {
    state.add(category);
    _setState();
  }

  void remove(Category category) {
    state.remove(category);
    _setState();
  }

  void favourite(Category category) {
    state.remove(category);
    state.add(
      Category(
        category.name,
        category.icon,
        !category.favourite,
        category.created,
      ),
    );
    state.sort((a, b) => b.favourite ? 1 : -1);
    _setState();
  }
}

class OptionMenuBloc extends Cubit<Category?> {
  OptionMenuBloc() : super(null);

  void set(Category? category) => emit(category);

  void clear() => emit(null);
}
