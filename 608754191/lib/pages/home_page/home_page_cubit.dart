import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_wtf/pages/entity/message.dart';
import 'package:task_wtf/util/database.dart';
import '../add_page/add_page.dart';
import '../chat_page/chat_page.dart';
import '../entity/category.dart';
import 'chose_of_action/chose_of_action.dart';
part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit()
      : super(
          HomePageState(
            category: null,
            categories: [],
          ),
        );
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void init() async {
    emit(
      state.copyWith(
        categories: <Category>[],
      ),
    );
    emit(
      state.copyWith(
        categories: await _databaseProvider.downloadCategoryList(),
      ),
    );
  }

  void updateCategory(Category category) {
    emit(
      state.copyWith(
        category: category,
      ),
    );
    _databaseProvider.updateCategory(
      category,
    );
  }

  void updateList(List<Category> categories) => emit(
        state.copyWith(categories: categories),
      );

  void deleteCategory(List<Category> categories, int index) {
    _databaseProvider.deleteCategory(
      categories[index],
    );
    _databaseProvider.deleteAllMessagesFromCategory(
      categories[index].categoryId,
    );
    categories.removeAt(index);
    emit(
      state.copyWith(categories: categories),
    );
  }

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
      state.categories.insert(0, newCategory);
      newCategory.categoryId = await _databaseProvider.insertCategory(newCategory);
    }
    emit(
      state.copyWith(
        categories: state.categories,
      ),
    );
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
      category: state.category,
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
