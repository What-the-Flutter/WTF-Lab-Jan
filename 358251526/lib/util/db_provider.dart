import 'package:path/path.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:sqflite/sqflite.dart';

import 'domain.dart';

const String tableCategories = 'categories';
const String categoryId = 'id';
const String categoryName = 'name';
const String indexOfIcon = 'icon_index';
const String categoryDate = 'category_date';

const String tableEvents = 'events';
const String eventId = 'event_id';
const String eventCategoryId = 'category_id';
const String eventDate = 'event_date';
const String eventText = 'event_text';


class DBProvider {
  static late final Database _database;
  static final DBProvider _dbProvider = DBProvider._createInstance();

  DBProvider._createInstance();

  factory DBProvider() {
    return _dbProvider;
  }

  static Future<void> initialize() async => _database = await initDatabase();

  static Database get database {
    return _database;
  }

  static Future<Database> initDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute('''
      create table $tableCategories(
      $categoryId integer primary key autoincrement,
      $categoryName text not null,
      $indexOfIcon integer,
      $categoryDate text not null) 
       ''');
        db.execute('''
         create table $tableEvents(
        $eventId integer primary key autoincrement,
        $eventCategoryId integer,
        $eventDate text not null,
        $eventText text not null)
       ''');
      },
    );
    return database;
  }

  Future<int> insertCategory(Category category) async {
    final db = await database;
    return db.insert(
      tableCategories,
      category.convertCategoryToMapWithId(),
    );
  }

  Future<int> deleteCategory(Category category) async {
    final db = await database;
    return db.delete(
      tableCategories,
      where: '$categoryId = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update(
      tableCategories,
      category.convertCategoryToMap(),
      where: '$categoryId = ?',
      whereArgs: [category.id],
    );
  }

  Future<List<Category>> fetchCategoriesList() async {
    final db = await database;
    final dbNotesList = await db.query(tableCategories);
    final categoriesList = <Category>[];
    for (var item in dbNotesList) {
      final category = Category.fromMap(item);
      categoriesList.insert(0, category);
    }
    return categoriesList;
  }

  Future<int> insertEvent(Event event) async {
    final db = await database;
    return db.insert(
      tableEvents,
      event.convertEventToMapWithId(),
    );
  }

  Future<int> deleteEvent(Event event) async {
    final db = await database;
    return await db.delete(
      tableEvents,
      where: '$eventId = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> deleteEventsFromCategory(int categoryId) async {
    final db = await database;
    return await db.delete(
      tableEvents,
      where: '$eventCategoryId = ?',
      whereArgs: [categoryId],
    );
  }

  Future<int> updateEvent(Event event) async {
    final db = await database;
    return await db.update(
      tableEvents,
      event.convertEventToMap(),
      where: '$eventId = ?',
      whereArgs: [event.id],
    );
  }

  Future<List<Event>> fetchEventsList(int categoryId) async {
    final eventsList = <Event>[];
    final db = await database;
    final dbEventsList = await db.rawQuery(
      'SELECT * FROM $tableEvents WHERE $eventCategoryId = ?',
      [categoryId],
    );
    for (var item in dbEventsList) {
      final event = Event.fromMap(item);
      eventsList.insert(0, event);
    }
    return eventsList;
  }

  Future<List<Event>> fetchFullEventsList() async {
    final db = await database;
    final eventList = <Event>[];
    final dbCategoriesList = await db.query(tableEvents);
    for (var element in dbCategoriesList) {
      final event = Event.fromMap(element);
      eventList.insert(0, event);
    }
    return eventList;
  }
}