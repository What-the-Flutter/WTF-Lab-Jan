import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/event.dart';
import '../models/event_type.dart';
import 'db_constants.dart';
import 'i_events_repository.dart';

class DBProvider implements IEventsRepository {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db;
    }

    // if _database is null we instantiate it
    _db = await initDB();
    return _db;
  }

  static Future<Database> initDB() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, DBConstants.database);
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (db, version) async {
      await db.execute('''
            CREATE TABLE ${DBConstants.eventTable} (
              ${DBConstants.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
              ${DBConstants.eventTypeId} INTEGER NOT NULL,
              ${DBConstants.eventDate} TEXT NOT NULL,
              ${DBConstants.eventMessage} TEXT NOT NULL,
              FOREIGN KEY ( ${DBConstants.eventTypeId}) REFERENCES ${DBConstants.eventTypeTable} (${DBConstants.id}) 
                ON DELETE NO ACTION ON UPDATE NO ACTION
            )''');

      await db.execute('''
            CREATE TABLE ${DBConstants.eventTypeTable} (
              ${DBConstants.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
              ${DBConstants.eventTypeTitle} TEXT NOT NULL UNIQUE,
              ${DBConstants.eventTypeIcon} TEXT NOT NULL UNIQUE
            )''');
    });
  }

  @override
  Future<List<EventType>> fetchEventTypeList() async {
    final db = await database;
    var res = await db.query(DBConstants.eventTypeTable);
    var list =
        res.isNotEmpty ? res.map((c) => EventType.fromMap(c)).toList() : [];
    return list;
  }

  @override
  Future<List<Event>> fetchEventsList(EventType eventType) async {
    final db = await database;
    var res = await db.query(DBConstants.eventTable,
        where: '${DBConstants.eventTypeId} = ?', whereArgs: [eventType.id],orderBy: '${DBConstants.eventDate} desc');
    var list =
    res.isNotEmpty ? res.map((c) => Event.fromJson(c)).toList() : [];
    return list;
  }

  @override
  Future<EventType> upsertEventType(EventType eventType) async {
    final db = await database;

    if (eventType.id == null) {
      await db.insert(
        DBConstants.eventTypeTable,
        eventType.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await db.update(DBConstants.eventTypeTable, eventType.toMap(),
          where: '${DBConstants.id} = ?', whereArgs: [eventType.id]);
    }
    return eventType;
  }

  @override
  Future<Event> upsertEvent(Event event) async {
    final db = await database;

    if (event.id == null) {
      event.id = await db.insert(DBConstants.eventTable, event.toJson());
    } else {
      await db.update(DBConstants.eventTable, event.toJson(),
          where: '${DBConstants.id} = ?', whereArgs: [event.id]);
    }
    return event;
  }

  @override
  Future<Event> deleteEvent(Event event) {
    // TODO: implement deleteEvent
    throw UnimplementedError();
  }

  @override
  Future<EventType> deleteEventType(EventType eventType) {
    // TODO: implement deleteEventType
    throw UnimplementedError();
  }
}
