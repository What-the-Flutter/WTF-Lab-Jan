import 'package:bloc/bloc.dart';
import 'package:chat_journal/model/category.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../extensions/list_get_element.dart';

part 'hometab_state.dart';

class HometabCubit extends Cubit<HometabState> {
  HometabCubit(List<Category> categories) : super(HometabInitial(categories));

  void pinCategory(Category category) {
    state.categories.get(category).isPinned = true;
    state.categories.sort();
    emit(CategoryPinSuccess(state.categories, category));
  }

  void unpinCategory(Category category) {
    state.categories.get(category).isPinned = false;
    state.categories.sort();
    emit(CategoryUnpinSuccess(state.categories, category));
  }

  void updateCategory(Category category, IconData newIconData, String newName) {
    state.categories.get(category)
      ..icon = newIconData
      ..name = newName;
    state.categories.sort();
    emit(CategoryUpdateSuccess(state.categories, category));
  }

  void deleteCategory(Category category) {
    state.categories.remove(category);
    emit(CategoryDeleteSuccess(state.categories, category));
  }

  void addCategory(Category category) {
    state.categories.add(category);
    state.categories.sort;
    emit(CategoryAddSuccess(state.categories, category));
  }
}
