import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../add_page/add_page.dart';
import '../../entity/category.dart';
part 'chose_of_action_state.dart';

class ChoseOfActionCubit extends Cubit<ChoseOfActionState> {
  ChoseOfActionCubit(List<Category> categories) : super(ChoseOfActionState(categories: categories));

  void updateCategory(BuildContext context, int index, BuildContext dialogContext) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddPage(
          indexOfCategory: index,
          categories: state.categories,
        ),
      ),
    );
    Navigator.pop(dialogContext);
    categoryListRedrawing();
  }

  void removeCategory(int index) {
    state.categories.removeAt(index);
    categoryListRedrawing();
  }

  void categoryListRedrawing() => emit(
        state.copyWith(categories: state.categories),
      );
}
