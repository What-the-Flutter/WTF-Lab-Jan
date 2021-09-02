import 'package:chat_journal/models/note_model.dart';
import 'package:chat_journal/models/event_model.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String tableNotes = 'notes';
const String columnId = 'id';
const String columnNameOfNote = 'name';
const String indexOfCircleAvatar = 'circle_avatar_index';
const String columnNameOfSubTittle = 'sub_tittle_name';
const String columnNoteDate = 'date';
const String columnSelected = 'is_selected';

const String tableEvents = 'events';
const String columnEventId = 'event_id';
const String columnNoteId = 'note_id';
const String columnTime = 'time';
const String columnText = 'text';
const String indexOfEventCircleAvatar = 'event_circle_avatar';
const String columnImagePath = 'image_path';
const String columnDate = 'date_format';
const String columnIsBookmarked = 'bookmark';
const String columnBookmarkCreateTime = 'bookmark_create_time';

class DBProvider {
  static const DBProvider _dbProvider = DBProvider._createInstance();
  static late final Database _database;

  const DBProvider._createInstance();

  factory DBProvider() {
    return _dbProvider;
  }

  static Future<void> initialize() async => _database = await initDatabase();

  static Database get database {
    return _database;
  }

  static Future<Database> initDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'core1.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute('''
      create table $tableNotes(
      $columnId integer primary key autoincrement,
      $columnNameOfNote text not null,
      $indexOfCircleAvatar integer,
      $columnNameOfSubTittle text not null,
      $columnNoteDate text not null,
      $columnSelected integer) 
       ''');
        db.execute('''
         create table $tableEvents(
        $columnEventId integer primary key autoincrement,
        $columnNoteId integer,
        $columnTime text not null,
        $columnText text not null,
        $indexOfEventCircleAvatar integer,
        $columnImagePath text,
        $columnDate text not null,
        $columnIsBookmarked integer,
        $columnBookmarkCreateTime text not null)
       ''');
      },
    );
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
      note.insertToMap(),
      where: '$columnId = ?',
      whereArgs: [note.id],
    );
  }

  Future<List<Event>> dbAllEventList() async {
    final db = await database;
    final eventList = <Event>[];
    final dbNotesList = await db.query(tableEvents);
    for (final element in dbNotesList) {
      final event = Event.fromMap(element);
      eventList.insert(0, event);
    }
    eventList.sort(
          (a, b) {
        var aDate = DateFormat().add_yMMMd().parse(a.date);
        var bDate = DateFormat().add_yMMMd().parse(b.date);
        return bDate.compareTo(aDate);
      },
    );
    return eventList;
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

  Future<List<bool>> dbAllBookmarks() async {
    final db = await database;
    final bookmarksList = <bool>[];
    final dbNotesList = await db.query(tableEvents);
    for (final element in dbNotesList) {
      final event = Event.fromMap(element);
      if (event.isBookmarked) {
        bookmarksList.insert(0, event.isBookmarked);
      }
    }
    return bookmarksList;
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

  Future<int> deleteAllEventFromNote(int noteId) async {
    final db = await database;
    return await db.delete(
      tableEvents,
      where: '$columnNoteId = ?',
      whereArgs: [noteId],
    );
  }

  Future<int> updateEvent(Event event) async {
    final db = await database;
    return await db.update(
      tableEvents,
      event.insertToMap(),
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
}