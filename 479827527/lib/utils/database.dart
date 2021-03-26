import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import '../event.dart';
import '../note_page.dart';

const String notesTable = 'notes';
const String columnNoteId = 'note_id';
const String columnTitle = 'title';
const String columnSubtitle = 'sub_title';
const String columnNoteCircleAvatarIndex = 'note_circle_avatar_index';

const String eventsTable = 'events';
const String columnEventId = 'event_id';
const String columnCurrentNoteId = 'current_note_id';
const String columnText = 'text';
const String columnTime = 'time';
const String columnEventCircleAvatarIndex = 'event_circle_avatar_index';

class DatabaseProvider {
  static DatabaseProvider _databaseProvider;
  static Database _database;

  DatabaseProvider._createInstance();

  Future<Database> get database async {
    return _database ?? await initDB();
  }

  factory DatabaseProvider() {
    return _databaseProvider ?? DatabaseProvider._createInstance();
  }

  Future<Database> initDB() async {
    return openDatabase(
        join(await getDatabasesPath(), 'chat_journal_database.db'),
        version: 1, onCreate: (db, version) {
      db.execute('''
      create table $notesTable(
      $columnNoteId integer primary key autoincrement,
      $columnTitle text not null,
      $columnSubtitle text not null,
      $columnNoteCircleAvatarIndex integer
      ) 
      ''');
      db.execute('''
       create table $eventsTable(
      $columnEventId integer primary key autoincrement,
      $columnCurrentNoteId integer,
      $columnText text not null,
      $columnTime text not null,
      $columnEventCircleAvatarIndex integer
      )
      ''');
    });
  }

  Future<int> insertNote(NotePage note) async {
    final db = await database;
    return db.insert(
      notesTable,
      note.convertNoteToMapWithId(),
    );
  }

  Future<int> deleteNote(NotePage note) async {
    final db = await database;
    return db.delete(
      notesTable,
      where: '$columnNoteId = ?',
      whereArgs: [note.noteId],
    );
  }

  Future<int> updateNote(NotePage note) async {
    final db = await database;
    return await db.update(
      notesTable,
      note.convertNoteToMap(),
      where: '$columnNoteId = ?',
      whereArgs: [note.noteId],
    );
  }

  void downloadNotesList(List<NotePage> noteList) async {
    final db = await database;
    final dbNotesList = await db.query(notesTable);
    for (final item in dbNotesList) {
      final note = NotePage.fromMap(item);
      noteList.insert(0, note);
    }
  }

  Future<int> insertEvent(Event event) async {
    final db = await database;
    return db.insert(
      eventsTable,
      event.convertEventToMapWithId(),
    );
  }

  Future<int> deleteEvent(Event event) async {
    final db = await database;
    return await db.delete(
      eventsTable,
      where: '$columnEventId = ?',
      whereArgs: [event.eventId],
    );
  }

  Future<int> updateEvent(Event event) async {
    final db = await database;
    return await db.update(
      eventsTable,
      event.convertEventToMap(),
      where: '$columnEventId = ?',
      whereArgs: [event.eventId],
    );
  }

  void downloadEventsList(List<Event> eventList, int noteId) async {
    final db = await database;
    var dbEventsList = await db.rawQuery(
      'SELECT * FROM $eventsTable WHERE $columnCurrentNoteId = ?',
      [noteId],
    );
    for (final item in dbEventsList) {
      final event = Event.fromMap(item);
      eventList.insert(0, event);
    }
  }
}
