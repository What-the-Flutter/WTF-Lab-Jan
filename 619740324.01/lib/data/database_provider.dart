import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../event.dart';
import '../note.dart';

const String tableNotes = 'notes';
const String columnId = 'id';
const String columnNameOfNote = 'name';
const String indexOfCircleAvatar = 'circle_avatar_index';
const String columnNameOfSubTittle = 'sub_tittle_name';

const String tableEvents = 'events';
const String columnEventId = 'event_id';
const String columnNoteId = 'note_id';
const String columnTime = 'time';
const String columnText = 'text';
const String indexOfEventCircleAvatar = 'event_circle_avatar';
const String columnEventBookmarkIndex = 'bookmark_index';
const String columnDate = 'date_format';

class DatabaseProvider {
  static Database? _database;
  static DatabaseProvider? _dbProvider;

  DatabaseProvider._createInstance();

  factory DatabaseProvider() {
    return _dbProvider ?? DatabaseProvider._createInstance();
  }

  Future<Database> get database async {
    return _database ?? await initDatabase();
  }

  Future<Database> initDatabase() async {
    return openDatabase(join(await getDatabasesPath(), 'database.db'),
        version: 1, onCreate: (db, version) {
      db.execute('''
      create table $tableNotes(
      $columnId integer primary key autoincrement,
      $columnNameOfNote text not null,
      $indexOfCircleAvatar integer,
      $columnNameOfSubTittle text not null) 
       ''');
      db.execute('''
         create table $tableEvents(
        $columnEventId integer primary key autoincrement,
        $columnNoteId integer,
        $columnTime text not null,
        $columnText text not null,
        $indexOfEventCircleAvatar integer,
        $columnEventBookmarkIndex integer,
        $columnDate text not null)
       ''');
    });
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    return db.insert(
      tableNotes,
      note.insertToMap(),
    );
  }

  Future<int> deleteNote(Note note) async {
    final db = await database;
    return await db.delete(
      tableNotes,
      where: '$columnId = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      tableNotes,
      note.toMap(),
      where: '$columnId = ?',
      whereArgs: [note.id],
    );
  }

  Future<List<Note>> dbNotesList() async {
    final db = await database;
    final noteList = <Note>[];
    final dbNotesList = await db.query(tableNotes);
    for (final element in dbNotesList) {
      final note = Note.fromMap(element);
      noteList.insert(0, note);
    }
    return noteList;
  }

  Future<int> insertEvent(Event event) async {
    final db = await database;
    return db.insert(
      tableEvents,
      event.insertToMap(),
    );
  }

  Future<int> deleteEvent(Event event) async {
    final db = await database;
    return await db.delete(
      tableEvents,
      where: '$columnEventId = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> updateEvent(Event event) async {
    final db = await database;
    return await db.update(
      tableEvents,
      event.toMap(),
      where: '$columnEventId = ?',
      whereArgs: [event.id],
    );
  }

  Future<List<Event>> dbEventList(int noteId) async {
    final db = await database;
    final eventList = <Event>[];
    var dbEventsList = await db.rawQuery(
      'SELECT * FROM $tableEvents WHERE $columnNoteId = ?',
      [noteId],
    );
    for (final element in dbEventsList) {
      final event = Event.fromMap(element);
      eventList.insert(0, event);
    }
    return eventList;
  }

  Future<List<Event>> fetchFullEventsList() async {
    final db = await database;
    final eventList = <Event>[];
    final dbEventsList = await db.query(tableEvents);
    for (final element in dbEventsList) {
      final event = Event.fromMap(element);
      eventList.insert(0, event);
    }
    return eventList;
  }
}
