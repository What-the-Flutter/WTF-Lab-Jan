import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../model/category.dart';
import '../../../model/record.dart';
import '../../../repositories/categories_repository.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesRepository repository;

  CategoriesCubit(this.repository) : super(CategoriesLoadInProcess(null));

  Future<List<CategoryWithLastRecord>> get categoriesWithLastRecords async {
    final categories = await repository.getAll();
    final categoriesWithLastRecords = <CategoryWithLastRecord>[];
    for (var category in categories) {
      categoriesWithLastRecords.add(
        CategoryWithLastRecord(
          category: category,
          lastRecord: await repository.getLastRecord(
            categoryId: category.id,
          ),
        ),
      );
    }
    return categoriesWithLastRecords;
  }

  void loadCategories() async {
    emit(
      CategoriesLoadSuccess(
        await categoriesWithLastRecords,
      ),
    );
  }

  void add({@required Category category}) async {
    await repository.insert(category);
    emit(
      CategoryAddSuccess(
        await categoriesWithLastRecords,
        category,
      ),
    );
  }

  void update(Category category) async {
    await repository.update(category);
    emit(
      CategoryUpdateSuccess(
        await categoriesWithLastRecords,
        category,
      ),
    );
  }

  void delete({@required int id}) async {
    final deletedCategory = await repository.delete(id);
    emit(
      CategoryDeleteSuccess(
        await categoriesWithLastRecords,
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
        await categoriesWithLastRecords,
        category,
      ),
    );
  }
}
