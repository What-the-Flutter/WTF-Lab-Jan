import 'dart:async';

import '../models/category.dart';
import 'database/database_provider.dart';
import 'mappers/category_mapper.dart';

class CategoryRepository {
  final DbProvider dbProvider;

  CategoryRepository(this.dbProvider);

  Future<List<Category>> fetchCategories() async {
    final dbCategories = await dbProvider.categories();
    return dbCategories.map(CategoryMapper.fromDb).toList();
  }

  Future<List<Category>> fetchDefaultCategories() async {
    final dbCategories = await dbProvider.categories(isDefault: true);
    return dbCategories.map(CategoryMapper.fromDb).toList();
  }

  Future<void> addCategory(Category category) async {
    return dbProvider.insertCategory(CategoryMapper.toDb(category));
  }

  Future<void> updateCategory(Category category) async {
    return dbProvider.updateCategory(CategoryMapper.toDb(category));
  }

  Future<void> switchPriority(Category category) async {
    final priority;
    if (category.priority == CategoryPriority.high) {
      priority = CategoryPriority.normal;
    } else {
      priority = CategoryPriority.high;
    }
    return dbProvider.updateCategory(CategoryMapper.toDb(category.copyWith(priority: priority)));
  }

  Future<void> deleteCategory(Category category) async {
    if (category.id != null) {
      return dbProvider.deleteCategory(category.id!);
    }
  }
}
