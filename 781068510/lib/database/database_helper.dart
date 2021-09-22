import 'package:notes/models/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _dbName = 'database.db';
  static final _dbVersion = 1;

  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  // factory DatabaseHelper() => instance ?? DatabaseHelper._init();
  factory DatabaseHelper() => instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future _initDatabase() async {
    var directory = await getDatabasesPath();
    var path = join(directory, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final integerNullType = 'INTEGER';
    final integerType = 'INTEGER NOT NULL';
    final stringType = 'STRING NOT NULL';
    final stringNullType = 'STRING';

    await db.execute('''
    CREATE TABLE $pagesTable(
    ${PagesFields.id} $idType,
    ${PagesFields.icon} $integerType,
    ${PagesFields.title} $stringType,
    ${PagesFields.lastEditDate} $stringType,
    ${PagesFields.lastMessage} $stringType,
    ${PagesFields.createDate} $stringType,
    ${PagesFields.isPinned} $boolType)
    ''');
    await db.execute('''
    CREATE TABLE $eventsTable(
    ${EventsFields.id} $idType,
    ${EventsFields.tableId} $integerType,
    ${EventsFields.description} $stringType,
    ${EventsFields.category} $integerType,
    ${EventsFields.time} $stringType,
    ${EventsFields.formattedTime} $stringType,
    ${EventsFields.isBookmarked} $boolType,
    ${EventsFields.image} $stringNullType)
    ''');
  }

  Future addPage(PageCategoryInfo page) async {
    final db = await instance.database;
    final id = await db.insert(pagesTable, page.toJson());
    return page.copyWith(id: id);
  }

  Future<PageCategoryInfo> readPage(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      pagesTable,
      columns: PagesFields.values,
      where: '${PagesFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return PageCategoryInfo.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<PageCategoryInfo>> readAllPages() async {
    final db = await instance.database;
    final result = await db.query(pagesTable);
    return result.map((json) => PageCategoryInfo.fromJson(json)).toList();
  }

  Future<int> updatePage(PageCategoryInfo page) async {
    final db = await instance.database;

    return db.update(
      pagesTable,
      page.toJson(),
      where: '${PagesFields.id} = ?',
      whereArgs: [page.id],
    );
  }

  Future<int> deletePage(int id) async {
    final db = await instance.database;

    return await db.delete(
      pagesTable,
      where: '${PagesFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteEventsFromNote(int pageId) async {
    final db = await database;
    return await db.delete(
      eventsTable,
      where: '$EventsFields.tableId = ?',
      whereArgs: [pageId],
    );
  }

  Future<List<Note>> readAllEvents(int index) async {
    final db = await instance.database;
    final result = await db.query(eventsTable);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<List<Note>> readAllEventsByIndex(int noteId) async {
    final eventsList = <Note>[];
    final db = await instance.database;
    final dbEventsList = await db.rawQuery(
      'SELECT * FROM $eventsTable WHERE ${EventsFields.tableId} = ?',
      [noteId],
    );
    for (var item in dbEventsList) {
      final event = Note.fromJson(item);
      eventsList.insert(0, event);
    }
    return eventsList;
  }

  Future<Note> readEvent(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      pagesTable,
      columns: EventsFields.values,
      where: '${EventsFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future addEvent(int pageIndex, Note note) async {
    final db = await instance.database;
    final id = await db.insert(eventsTable, note.toJson());
    return note.copyWith(
      id: id,
    );
  }

  Future replyEvent(int pageIndex, Note note) async {
    final db = await instance.database;
    final id = await db.insert(eventsTable, note.toJson());
    return note.copyWith(
      id: id,
      tableId: pageIndex,
    );
  }

  Future<int> updateEvent(int pageIndex, Note event) async {
    final db = await instance.database;

    return db.update(
      eventsTable,
      event.toJson(),
      where: '${EventsFields.id} = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> deleteEvent(int pageIndex, int id) async {
    final db = await instance.database;

    return await db.delete(
      eventsTable,
      where: '${EventsFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
