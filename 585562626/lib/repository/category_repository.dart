import 'dart:async';

import '../models/category.dart';
import 'database/database_provider.dart';
import 'mappers/category_mapper.dart';

class CategoryRepository {
  final DbProvider dbProvider;

  CategoryRepository(this.dbProvider);

  Future<List<NoteCategory>> fetchCategories() async {
    final dbCategories = await dbProvider.categories();
    return dbCategories.map(CategoryMapper.fromDb).toList();
  }

  Future<List<NoteCategory>> fetchDefaultCategories() async {
    final dbCategories = await dbProvider.categories(isDefault: true);
    return dbCategories.map(CategoryMapper.fromDb).toList();
  }

  Future<void> addCategory(NoteCategory category) async {
    return await dbProvider.insertCategory(CategoryMapper.toDb(category));
  }

  Future<void> updateCategory(NoteCategory category) async {
    return await dbProvider.updateCategory(CategoryMapper.toDb(category));
  }

  Future<void> switchPriority(NoteCategory category) async {
    final priority;
    if (category.priority == CategoryPriority.high) {
      priority = CategoryPriority.normal;
    } else {
      priority = CategoryPriority.high;
    }
    return await dbProvider
        .updateCategory(CategoryMapper.toDb(category.copyWith(priority: priority)));
  }

  Future<void> deleteCategory(NoteCategory category) async {
    if (category.id != null) {
      return await dbProvider.deleteCategory(category.id!);
    }
    return;
  }
}
