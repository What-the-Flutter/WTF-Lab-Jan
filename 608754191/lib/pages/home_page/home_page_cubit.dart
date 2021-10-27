import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../entity/category.dart';
import '../../repositories/database.dart';
import '../add_page/add_page.dart';
part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit()
      : super(
          HomePageState(),
        );
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  void init() async {
    updateList(
      [],
    );
    emit(
      state.copyWith(
        categories: await _databaseProvider.fetchCategoryList(),
      ),
    );
  }

  void updateList(List<Category> categories) {
    emit(
      state.copyWith(categories: categories),
    );
  }

  void deleteCategory(List<Category> categories, int index) {
    _databaseProvider.deleteCategory(
      categories[index],
    );
    _databaseProvider.deleteAllMessagesFromCategory(
      categories[index].categoryId!,
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
      state.categories.insert(0, newCategory);
      newCategory.categoryId = await _databaseProvider.insertCategory(newCategory);
    }
    emit(
      newCategory != null
          ? CategoryAddedSuccess(newCategory, state.categories)
          : state.copyWith(
              categories: state.categories,
            ),
    );
  }

  void update(BuildContext context, int index) async {
    final newCategory = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddPage.add(),
      ),
    );
    if (newCategory is Category) {
      state.categories.removeAt(index);
      state.categories.insert(
        index,
        newCategory,
      );
    }

    categoryListRedrawing();
  }
}
