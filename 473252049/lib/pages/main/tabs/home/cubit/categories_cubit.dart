import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../model/category.dart';
import '../../../../../model/record.dart';
import '../../../../../repositories/categories_repository.dart';
import '../../../../../repositories/records_repository.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesRepository categoriesRepository;
  final RecordsRepository recordsRepository;

  CategoriesCubit({this.categoriesRepository, this.recordsRepository})
      : super(CategoriesLoadInProcess(null));

  Future<List<CategoryWithLastRecord>> get categoriesWithLastRecords async {
    final categories = await categoriesRepository.getAll();
    final categoriesWithLastRecord = <CategoryWithLastRecord>[];
    for (var category in categories) {
      categoriesWithLastRecord.add(
        CategoryWithLastRecord(
          category: category,
          lastRecord: await recordsRepository.getLastFromCategory(
            categoryId: category.id,
          ),
        ),
      );
    }
    return categoriesWithLastRecord;
  }

  Future<Category> getById(int categoryId) async {
    return await categoriesRepository.getById(categoryId);
  }

  void loadCategories() async {
    emit(
      CategoriesLoadSuccess(
        await categoriesWithLastRecords,
      ),
    );
  }

  void add({@required Category category}) async {
    await categoriesRepository.insert(category);
    emit(
      CategoryAddSuccess(
        await categoriesWithLastRecords,
        category,
      ),
    );
  }

  void addAll({@required List<Category> categories}) async {
    for (var category in categories) {
      await categoriesRepository.insert(category);
    }
    emit(AllAddSuccess(await categoriesWithLastRecords, categories));
  }

  void update(Category category) async {
    await categoriesRepository.update(category);
    emit(
      CategoryUpdateSuccess(
        await categoriesWithLastRecords,
        category,
      ),
    );
  }

  void delete({@required int id}) async {
    final deletedCategory = await categoriesRepository.delete(id);
    emit(
      CategoryDeleteSuccess(
        await categoriesWithLastRecords,
        deletedCategory,
      ),
    );
  }

  void deleteAll() async {
    final categoriesId = (await categoriesRepository.getAll()).map((e) => e.id);
    for (var id in categoriesId) {
      await categoriesRepository.delete(id);
    }
    emit(AllDeleteSuccess([]));
  }

  void changePin({@required Category category}) async {
    category.isPinned = !category.isPinned;
    await categoriesRepository.update(
      category,
    );
    emit(
      CategoryChangePinSuccess(
        await categoriesWithLastRecords,
        category,
      ),
    );
  }

  void unpinAll() async {
    for (var categoryWithLastRecord in state.categories) {
      if (categoryWithLastRecord.category.isPinned) {
        categoryWithLastRecord.category.isPinned = false;
        await categoriesRepository.update(categoryWithLastRecord.category);
      }
    }
    emit(
      AllUnpinSuccess(
        state.categories,
      ),
    );
  }
}
