import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/activity_page.dart';
import '../model/event.dart';

const String tableActivityPages = 'activity_pages';
const String tableEvents = 'events';

class JournalDatabase {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    //if (_database != null) await deleteDatabase('journal_database.db');

    _database = await _initDB('journal_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'text primary key';
    final textType = 'text not null';
    final textTypeNull = 'text';
    final integerType = 'integer not null';
    await db.execute('''
        create table $tableActivityPages ( 
          id $idType, 
          name $textType,
          icon $textType,
          creation_date $textType,
          is_pinned $integerType
          )
     ''');
    await db.execute('''
        create table $tableEvents ( 
          id $idType, 
          event_data $textType,
          image_path $textType,
          category_icon $textTypeNull,
          category_name $textTypeNull,
          creation_date $textType,
          page_id $textType,
          is_selected $integerType,
          is_marked $integerType
          )
    ''');
  }

  Future<void> insertActivityPage(ActivityPage page) async {
    final db = await database;
    db.insert(
      tableActivityPages,
      page.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateActivityPage(ActivityPage page) async {
    final db = await database;
    await db.update(
      tableActivityPages,
      page.toMap(),
      where: 'id = ?',
      whereArgs: [page.id],
    );
  }

  Future<List<ActivityPage>> fetchActivityPageList() async {
    final db = await database;
    final dbPageList = await db.query(tableActivityPages);
    final pageList = <ActivityPage>[];
    for (final page in dbPageList) {
      final activityPage = ActivityPage.fromMap(page);
      //pageList.insert(0, page);
      pageList.add(activityPage);
    }
    return pageList;
  }

  Future<void> deleteActivityPage(ActivityPage page) async {
    final db = await database;
    db.delete(
      tableActivityPages,
      where: 'id = ?',
      whereArgs: [page.id],
    );
  }

  Future<void> insertEvent(Event event) async {
    final db = await database;
    db.insert(
      tableEvents,
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteEvent(Event event) async {
    final db = await database;
    db.delete(
      tableEvents,
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<List<Event>> fetchEventList(String pageId) async {
    final db = await database;
    final dbEventList =
        await db.query('$tableEvents where page_id = "$pageId"');
    final eventList = <Event>[];
    for (final event in dbEventList) {
      final pageEvent = Event.fromMap(event);
      //eventList.insert(0, event);
      eventList.add(pageEvent);
    }
    return eventList;
  }

  Future<List<Event>> fetchSelectedEventList() async {
    final db = await database;
    final dbEventList = await db.query('$tableEvents where is_selected = true');
    final eventList = <Event>[];
    for (final event in dbEventList) {
      final selectedEvent = Event.fromMap(event);
      //eventList.insert(0, event);
      eventList.add(selectedEvent);
    }
    return eventList;
  }

  Future<List<Event>> fetchAllMarkEventList(String pageId) async {
    final db = await database;
    final dbEventList = await db
        .query('$tableEvents where page_id = "$pageId" and is_marked = true');
    final eventList = <Event>[];
    for (final event in dbEventList) {
      final markedEvent = Event.fromMap(event);
      //eventList.insert(0, event);
      eventList.add(markedEvent);
    }
    return eventList;
  }

  Future<List<Event>> fetchSearchedEventList(String pageId, String text) async {
    final db = await database;
    final dbEventList = await db.query(
        '$tableEvents where page_id = "$pageId" and event_data like "%$text%"');
    final eventList = <Event>[];
    for (final event in dbEventList) {
      final searchedEvent = Event.fromMap(event);
      //eventList.insert(0, event);
      eventList.add(searchedEvent);
    }
    return eventList;
  }

  Future<void> updateEvent(Event event) async {
    final db = await database;
    await db.update(
      tableEvents,
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }
}
