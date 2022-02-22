import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note_model.dart';
import '../models/page_model.dart';
import '../services/entity_repository.dart';

const String tablePages = 'pages';
const String columnPageId = 'page_id';
const String columnTitle = 'title';
const String columnPageIcon = 'icon';
const String columnNumOfNotes = 'num_of_notes';
const String columnCretionDate = 'cretion_date';
const String columnLastModifedDate = 'last_modifed_date';

const String tableNotes = 'notes';
const String columnNoteId = 'note_id';
const String columnHeading = 'heading';
const String columnData = 'data';
const String columnNoteIcon = 'icon';
const String columnIsFavorite = 'is_favorite';
const String columnIsSearched = 'is_searched';
const String columnIsChecked = 'is_checked';
const String columnTags = 'tags';

class SqlitePageRepository extends IRepository<PageModel> {
  static final SqlitePageRepository _sqlitePageHelper =
      SqlitePageRepository._createInstance();
  static late final Database _database;

  SqlitePageRepository._createInstance();

  factory SqlitePageRepository() {
    return _sqlitePageHelper;
  }

  static Future<void> initialize() async => _database = await initDatabase();

  static Database get database {
    return _database;
  }

  static Future<Database> initDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'main5.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute('''
         create table $tablePages(
        $columnPageId integer primary key autoincrement,   
        $columnTitle text,
        $columnPageIcon integer,
        $columnNumOfNotes integer,
        $columnCretionDate text not null,
        $columnLastModifedDate text not null)
       ''');
        db.execute('''
         create table $tableNotes(
        $columnNoteId integer primary key autoincrement,  
        $columnHeading text,
        $columnPageId integer not null,
        $columnData text not null,
        $columnNoteIcon integer not null,
        $columnIsFavorite integer,
        $columnIsSearched integer,
        $columnIsChecked integer,
        $columnTags text) 
       ''');
      },
    );
    return database;
  }

  @override
  void delete(PageModel entity, int? pageId) async {
    final db = await database;
    final sqliteNoteRepository = SqliteNoteRepository();
    db.delete(
      tablePages,
      where: '$columnPageId = ?',
      whereArgs: [entity.id],
    );
    sqliteNoteRepository.deleteAllNotesFromPage(entity.id);
  }

  @override
  Future<List<PageModel>> getEntityList(int? pageId) async {
    final db = await database;
    final pagesList = <PageModel>[];
    final dbPagesList = await db.query(tablePages);
    final sqliteNoteRepository = SqliteNoteRepository();
    for (final dbPage in dbPagesList) {
      var page = PageModel.fromMap(dbPage);
      page = page.copyWith(
          notesList: await sqliteNoteRepository.getEntityList(page.id));
      pagesList.add(page);
    }
    return pagesList;
  }

  @override
  void insert(PageModel entity, int? pageId) async {
    final db = await database;
    db.insert(
      tablePages,
      entity.toMap(),
    );
  }

  @override
  void update(PageModel entity, int? pageId) async {
    final db = await database;
    db.update(
      tablePages,
      entity.toMap(),
      where: '$columnPageId = ?',
      whereArgs: [entity.id],
    );
  }
}

class SqliteNoteRepository extends IRepository<NoteModel> {
  static final SqliteNoteRepository _sqlitePageHelper =
      SqliteNoteRepository._createInstance();
  static late final Database _database;

  SqliteNoteRepository._createInstance();

  factory SqliteNoteRepository() {
    return _sqlitePageHelper;
  }

  static Future<void> initialize() async => _database = await initDatabase();

  static Database get database {
    return _database;
  }

  static Future<Database> initDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'main5.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute('''
         create table $tablePages(
        $columnPageId integer primary key autoincrement,   
        $columnTitle text,
        $columnPageIcon integer,
        $columnNumOfNotes integer,
        $columnCretionDate text not null,
        $columnLastModifedDate text not null)
       ''');
        db.execute('''
         create table $tableNotes(
        $columnNoteId integer primary key autoincrement,  
        $columnHeading text,
        $columnPageId integer not null,
        $columnData text not null,
        $columnNoteIcon integer not null,
        $columnIsFavorite integer,
        $columnIsSearched integer,
        $columnIsChecked integer,
        $columnTags text) 
       ''');
      },
    );
    return database;
  }

  Future<int> deleteAllNotesFromPage(int pageId) async {
    final db = await database;
    return await db.delete(
      tableNotes,
      where: '$columnPageId = ?',
      whereArgs: [pageId],
    );
  }

  @override
  void delete(NoteModel entity, int? pageId) async {
    final db = await database;
    db.delete(
      tableNotes,
      where: '$columnNoteId = ?',
      whereArgs: [entity.id],
    );
  }

  @override
  Future<List<NoteModel>> getEntityList(int? pageId) async {
    final db = await database;
    final notesList = <NoteModel>[];
    final dbNotesList = await db.rawQuery(
      'SELECT * FROM $tableNotes WHERE $columnPageId = ?',
      [pageId],
    );
    for (final dbNote in dbNotesList) {
      final note = NoteModel.fromMap(dbNote);
      notesList.add(note);
    }
    return notesList;
  }

  @override
  void insert(NoteModel entity, int? pageId) async {
    final db = await database;
    db.insert(
      tableNotes,
      entity.toMap(pageId!),
    );
  }

  @override
  void update(NoteModel entity, int? pageId) async {
    final db = await database;
    await db.update(
      tableNotes,
      entity.toMap(pageId!),
      where: '$columnNoteId = ?',
      whereArgs: [entity.id],
    );
  }
}
