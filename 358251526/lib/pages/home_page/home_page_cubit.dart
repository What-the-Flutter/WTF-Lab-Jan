import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/domain.dart';

import '../add_page/add_category_page.dart';
import '../chat_page/chat_page.dart';
import 'select_category_action_dialog.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit(List<Category> categoriesList)
      : super(
          HomePageState(categoriesList: categoriesList),
        );

  void removeCategory(int index) {
    state.categoriesList.removeAt(index);
    categoryListRedrawing();
  }

  void categoryListRedrawing() => emit(
        state.copyWith(categoriesList: state.categoriesList),
      );

  void init(List<Category> categoryList) => emit(
        state.copyWith(categoriesList: categoryList),
      );

  void addCategory(BuildContext context) async {
    final newCategory = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddCategoryPage.add(),
      ),
    );
    if (newCategory is Category) {
      state.categoriesList.add(newCategory);
    }
    categoryListRedrawing();
  }

  void selectCategoryAction(int index, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return SelectCategoryWidgetDialog(context, state.categoriesList, index);
      },
    );
  }

  void openChat(int index, BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Chat(
          category: state.categoriesList[index],
          categoriesList: state.categoriesList,
        ),
      ),
    );
    emit(
      state.copyWith(categoriesList: state.categoriesList),
    );
  }

  void updateCategory(
      BuildContext context, int index, BuildContext dialogContext) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddCategoryPage(
          indexOfCategory: index,
          categoriesList: state.categoriesList,
          isEditing: true,
        ),
      ),
    );
    Navigator.pop(dialogContext);
    categoryListRedrawing();
  }
}
