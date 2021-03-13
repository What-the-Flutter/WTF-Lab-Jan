import 'package:chat_journal/model/category.dart';
import 'package:chat_journal/repositories/categories_repository.dart';
import 'package:chat_journal/repositories/local_database/provider/local_database_provider.dart';
import 'package:chat_journal/repositories/repository.dart';

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
}
