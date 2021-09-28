import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../add_page/add_page.dart';
import '../../entity/category.dart';
part 'chose_of_action_state.dart';

class ChoseOfActionCubit extends Cubit<ChoseOfActionState> {
  ChoseOfActionCubit(List<Category> categories, int index)
      : super(ChoseOfActionState(categories: categories, index: index));

  void removeCategory(BuildContext context, int index) {
    state.categories.removeAt(index);
    Navigator.pop(context);
    categoryListRedrawing();
  }

  void categoryListRedrawing() => emit(
        state.copyWith(categories: state.categories),
      );

  void update(BuildContext context, List<Category> categories, int index) async {
    final newCategory = await Navigator.of(context).pushNamed('/add_page') as Category;
    newCategory.listMessages = categories[index].listMessages;

    state.categories.removeAt(index);
    state.categories.insert(
      index,
      newCategory,
    );
    categoryListRedrawing();
    Navigator.pop(context);
  }
}
