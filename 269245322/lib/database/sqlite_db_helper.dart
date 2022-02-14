import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note_model.dart';
import '../models/page_model.dart';

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

class DBHelper {
  static const DBHelper _dbHelper = DBHelper._createInstance();
  static late final Database _database;

  const DBHelper._createInstance();

  factory DBHelper() {
    return _dbHelper;
  }

  static Future<void> initialize() async => _database = await initDatabase();

  static Database get database {
    return _database;
  }

  static Future<Database> initDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'main1.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute('''
         create table $tablePages(
        $columnTitle text primary key,
        $columnPageIcon integer,
        $columnNumOfNotes integer,
        $columnCretionDate text not null,
        $columnLastModifedDate text not null)
       ''');
        db.execute('''
         create table $tableNotes(
        $columnHeading text primary key,
        $columnTitle integer not null,
        $columnData text not null,
        $columnNoteIcon integer not null,
        $columnIsFavorite integer,
        $columnIsSearched integer,
        $columnIsChecked integer) 
       ''');
      },
    );
    return database;
  }

  Future<int> insertPage(PageModel page) async {
    final db = await database;
    return db.insert(
      tablePages,
      page.toMap(),
    );
  }

  Future<int> deletePage(PageModel page) async {
    final db = await database;
    return await db.delete(
      tablePages,
      where: '$columnTitle = ?',
      whereArgs: [page.title],
    );
  }

  Future<int> updatePage(PageModel page, String oldTitle) async {
    final db = await database;
    return await db.update(
      tablePages,
      page.toMap(),
      where: '$columnTitle = ?',
      whereArgs: [oldTitle],
    );
  }

  Future<List<PageModel>> dbPagesList() async {
    final db = await database;
    final pagesList = <PageModel>[];
    final dbPagesList = await db.query(tablePages);
    for (final dbPage in dbPagesList) {
      var page = PageModel.fromMap(dbPage);
      page = page.copyWith(notesList: await dbNotesList(page.title));
      pagesList.add(page);
    }
    return pagesList;
  }

  Future<int> insertNote(NoteModel note, String pageTitle) async {
    final db = await database;
    return db.insert(
      tableNotes,
      note.toMap(pageTitle),
    );
  }

  Future<int> updateNote(NoteModel note, String pageTitle) async {
    final db = await database;
    return await db.update(
      tableNotes,
      note.toMap(pageTitle),
      where: '$columnHeading = ?',
      whereArgs: [note.heading],
    );
  }

  Future<int> deleteNote(NoteModel note) async {
    final db = await database;
    return await db.delete(
      tableNotes,
      where: '$columnHeading = ?',
      whereArgs: [note.heading],
    );
  }

  Future<int> deleteAllNotesFromPage(String pageTitle) async {
    final db = await database;
    return await db.delete(
      tableNotes,
      where: '$columnTitle = ?',
      whereArgs: [pageTitle],
    );
  }

  Future<List<NoteModel>> dbNotesList(String pageTitle) async {
    final db = await database;
    final notesList = <NoteModel>[];
    var dbNotesList = await db.rawQuery(
      'SELECT * FROM $tableNotes WHERE $columnTitle = ?',
      [pageTitle],
    );
    for (final dbNote in dbNotesList) {
      final note = NoteModel.fromMap(dbNote);
      notesList.add(note);
    }
    return notesList;
  }
}
