import 'package:bloc/bloc.dart';
import 'package:chat_journal/model/category.dart';
import 'package:chat_journal/repositories/categories_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesRepository repository;

  CategoriesCubit(this.repository) : super(CategoriesLoadInProcess(null));

  void loadCategories() async {
    emit(
      CategoriesLoadSuccess(
        await repository.getAll(),
      ),
    );
  }

  void add({@required Category category}) async {
    await repository.insert(category);
    emit(
      CategoryAddSuccess(
        await repository.getAll(),
        category,
      ),
    );
  }

  void update(Category category) async {
    await repository.update(category);
    emit(
      CategoryUpdateSuccess(
        await repository.getAll(),
        category,
      ),
    );
  }

  void delete({@required int id}) async {
    final deletedCategory = await repository.delete(id);
    emit(
      CategoryDeleteSuccess(
        await repository.getAll(),
        deletedCategory,
      ),
    );
  }

  void changePin({@required Category category}) async {
    category.isPinned = !category.isPinned;
    await repository.update(
      category,
    );
    emit(
      CategoryChangePinSuccess(
        await repository.getAll(),
        category,
      ),
    );
  }
}
