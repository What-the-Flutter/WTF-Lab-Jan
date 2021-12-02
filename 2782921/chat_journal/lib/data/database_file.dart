import 'package:chat_journal/entity/category_page.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseFile {
  static late Database _db;

  static Future<void> initialize() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE categories('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' title TEXT, iconIndex INTEGER,'
          ' creationTime INTEGER'
          ');',
        );
        db.execute(
          'CREATE TABLE messages('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' pageId INTEGER,'
          ' iconIndex INTEGER,'
          ' isFavourite INTEGER,'
          ' content TEXT,'
          ' creationTime INTEGER,'
          ');',
        );
      },
      version: 1,
    );
  }

  Future<List<CategoryPage>> fetchPages() async {
    final List<Map<String, dynamic>> categoriesMap =
        await _db.query('categories');

    final pages = List<CategoryPage>.generate(
      categoriesMap.length,
      (i) => CategoryPage.fromDb(
          categoriesMap[i]['id'],
          categoriesMap[i]['title'],
          categoriesMap[i]['iconIndex'],
          DateTime.now()),
    );

    return pages;
  }

  Future<int> insertPage(CategoryPage page) async {
    return _db.insert(
      'categories',
      page.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updatePage(CategoryPage page) async {
    _db.update(
      'categories',
      page.toMap(),
      where: 'id = ?',
      whereArgs: [page.id],
    );
  }

  Future<void> deletePage(CategoryPage page) async {
    _db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [page.id],
    );
  }
}
