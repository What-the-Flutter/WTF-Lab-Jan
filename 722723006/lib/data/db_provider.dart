import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../event_page/event.dart';
import '../note_page/note.dart';

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

class DBProvider {
  static Database _database;
  static Database _eventDatabase;
  static DBProvider _dbProvider;

  DBProvider._createInstance();

  factory DBProvider() {
    _dbProvider ??= DBProvider._createInstance();
    return _dbProvider;
  }

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    final database = openDatabase(join(await getDatabasesPath(), 'database.db'),
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
        $indexOfEventCircleAvatar integer)
       ''');
    });
    return database;
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

  void dbNotesList(List<Note> noteList) async {
    final db = await database;
    final dbNotesList = await db.query(tableNotes);
    for (final element in dbNotesList) {
      final note = Note.fromMap(element);
      noteList.insert(0, note);
    }
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

  void dbEventList(List<Event> eventList, int noteId) async {
    final db = await database;
    var dbEventsList = await db.rawQuery(
      'SELECT * FROM $tableEvents WHERE $columnNoteId = ?',
      [noteId],
    );
    for (final element in dbEventsList) {
      final event = Event.fromMap(element);
      eventList.insert(0, event);
    }
  }
}
