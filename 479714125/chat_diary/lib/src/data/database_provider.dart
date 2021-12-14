import 'dart:async';

import 'package:chat_diary/src/models/event_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/page_model.dart';
import '../resources/default_pages.dart';

class DatabaseProvider {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databaseName = 'app_database.db';
    final databaseLocation = await getDatabasesPath();
    final path = join(databaseLocation, databaseName);
    final database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);

    return database;
  }

  FutureOr<void> _createDatabase(Database database, int version) async {
    await database.execute('''
    CREATE TABLE pages(
      id INTEGER PRIMARY KEY,
      name TEXT,
      icon INTEGER,
      nextEventId INTEGER
    )
    ''');
    await database.execute('''
    CREATE TABLE events(
      id INTEGER PRIMARY KEY,
      pageId INTEGER,
      text TEXT,
      image TEXT,
      date TEXT,
      isSelected INTEGER,
      category INTEGER
    )
    ''');
    for (var page in defaultPages) {
      database.insert(
        'pages',
        page.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<PageModel>> retrievePages() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('pages');

    return List.generate(
      maps.length,
      (index) => PageModel.fromMap(maps[index]),
    );
  }

  Future<int> insertPage(PageModel page) async {
    final db = await database;

    return await db.insert(
      'pages',
      page.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deletePage(PageModel page) async {
    final db = await database;

    await db.delete(
      'pages',
      where: 'id = ?',
      whereArgs: [page.id],
    );
  }

  Future<int> updatePage(PageModel page) async {
    final db = await database;

    return await db.update(
      'pages',
      page.toMap(),
      where: 'id = ?',
      whereArgs: [page.id],
    );
  }

  Future<List<EventModel>> retrieveEvents() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('events');

    return List.generate(
      maps.length,
      (index) => EventModel.fromMap(maps[index]),
    );
  }
}
