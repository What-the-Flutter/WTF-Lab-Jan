import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model/model_message.dart';
import 'model/model_page.dart';

class PagesAPI {
  Database _database;

  Future<void> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE msg('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' pageId INTEGER,'
          ' isFavor INTEGER,'
          ' isSelected INTEGER,'
          ' text TEXT,'
          ' photo TEXT,'
          ' indexCategory INTEGER,'
          ' pubTime TEXT'
          ');',
        );
        db.execute(
          'CREATE TABLE pages('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' title TEXT, iconIndex INTEGER,'
          ' isPin INTEGER,'
          ' creationTime TEXT,'
          ' lastModifiedTime TEXT'
          ');',
        );
      },
      version: 1,
    );
  }

  Future<void> insertPage(ModelPage page) async {
    final db = await _database;

    await db.insert(
      'pages',
      page.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ModelPage>> pages() async {
    final db = await _database;

    final List<Map<String, dynamic>> maps = await db.query('pages');

    return List.generate(
      maps.length,
      (i) => ModelPage(
        id: maps[i]['id'],
        title: maps[i]['title'],
        iconIndex: maps[i]['iconIndex'],
        isPin: maps[i]['isPin'] == 0 ? false : true,
        creationTime: DateTime.parse(maps[i]['creationTime']),
        lastModifiedTime: DateTime.parse(maps[i]['lastModifiedTime']),
      ),
    );
  }

  Future<void> updatePage(ModelPage page) async {
    final db = await _database;

    await db.update(
      'pages',
      page.toMap(),
      where: 'id = ?',
      whereArgs: [page.id],
    );
  }

  Future<void> deletePage(int id) async {
    final db = await _database;
    await db.delete(
      'pages',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<ModelMessage>> messages(int pageId) async {
    final db = await _database;
    print(db);

    final List<Map<String, dynamic>> maps = await db.query(
      'msg',
      where: 'pageId = ?',
      whereArgs: [pageId],
    );
    return List.generate(
      maps.length,
      (i) => ModelMessage(
        id: maps[i]['id'],
        pageId: maps[i]['pageId'],
        isFavor: maps[i]['isFavor'] == 0 ? false : true,
        isSelected: maps[i]['isSelected'] == 0 ? false : true,
        text: maps[i]['text'],
        photo: maps[i]['photo'],
        indexCategory: maps[i]['indexCategory'],
        pubTime: DateTime.parse(maps[i]['pubTime']),
      ),
    );
  }

  Future<void> insertMessage(ModelMessage msg) async {
    final db = await _database;

    await db.insert(
      'msg',
      msg.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMessage(ModelMessage msg) async {
    final db = await _database;

    await db.update(
      'msg',
      msg.toMap(),
      where: 'id = ?',
      whereArgs: [msg.id],
    );
  }

  Future<void> deleteMessage(int id) async {
    final db = await _database;
    await db.delete(
      'msg',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteMessages(int pageId) async {
    final db = await _database;

    await db.delete(
      'msg',
      where: 'pageId = ?',
      whereArgs: [pageId],
    );
  }

  @override
  String toString() {
    return 'PagesAPI{_database: $_database}';
  }
}
