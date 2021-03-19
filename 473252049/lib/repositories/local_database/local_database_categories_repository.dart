import 'package:flutter/material.dart';

import '../../model/category.dart';
import '../../model/record.dart';
import '../categories_repository.dart';
import 'provider/local_database_provider.dart';

class LocalDatabaseCategoriesRepository extends LocalDatabaseProvider
    implements CategoriesRepository {
  @override
  Future<void> insert(Category category) async {
    (await database).insert(
      'categories',
      category.toMap(),
    );
  }

  @override
  Future<void> update(Category category) async {
    await (await database).update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  @override
  Future<Category> delete(int id) async {
    final category = Category.fromMap(
      (await (await database).query(
        'categories',
        where: 'id = ?',
        whereArgs: [id],
      ))
          .first,
    );
    await (await database).delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    await (await database).delete(
      'records',
      where: 'categoryId = ?',
      whereArgs: [id],
    );
    return category;
  }

  @override
  Future<List<Category>> getAll() async {
    return (await (await database).query(
      'categories',
      orderBy: 'isPinned DESC, name ASC',
    ))
        .map((e) => Category.fromMap(e))
        .toList();
  }

  @override
  Future<Record> getLastRecord({@required int categoryId}) async {
    final records = (await (await database).query(
      'records',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
      orderBy: 'createDateTime DESC',
      limit: 1,
    ))
        .map((e) => Record.fromMap(e))
        .toList();
    return records.isEmpty ? null : records.first;
  }
}
