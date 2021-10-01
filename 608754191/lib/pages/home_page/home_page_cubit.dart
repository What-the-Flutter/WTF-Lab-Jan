import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../add_page/add_page.dart';
import '../chat_page/chat_page.dart';
import '../entity/category.dart';
import 'chose_of_action/chose_of_action.dart';
part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit(List<Category> categoriesList)
      : super(
          HomePageState(categories: categoriesList),
        );

  void init(List<Category> categoryList) => emit(
        state.copyWith(categories: categoryList),
      );

  void categoryListRedrawing() => emit(
        state.copyWith(categories: state.categories),
      );

  void addCategory(BuildContext context) async {
    final newCategory = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddPage.add(),
      ),
    );
    if (newCategory is Category) {
      state.categories.add(newCategory);
    }
    categoryListRedrawing();
  }

  void choseOfAction(int index, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        child: ChoseOfAction(
          state.categories,
          index - 1,
        ),
        value: BlocProvider.of<HomePageCubit>(
          context,
        ),
      ),
    );
  }

  void openChat(int index, BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          category: state.categories[index],
          categories: state.categories,
        ),
      ),
    );
    emit(
      state.copyWith(categories: state.categories),
    );
  }

  void removeCategory(int index) {
    final newState = HomePageState(
      categories: state.categories
        ..removeAt(
          index,
        ),
    );
    emit(
      newState,
    );
  }

  void update(BuildContext context, List<Category> categories, int index) async {
    final newCategory = await Navigator.of(context).pushNamed('/add_page') as Category;
    // newCategory.listMessages = categories[index].listMessages;

    state.categories.removeAt(
      index,
    );
    state.categories.insert(
      index,
      newCategory,
    );
    categoryListRedrawing();
    Navigator.pop(
      context,
    );
  }
}
