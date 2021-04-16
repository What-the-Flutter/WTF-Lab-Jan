import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../../constants/db_constants.dart';
import '../../di/i_events_repository.dart';
import '../../models/event.dart';
import '../../models/event_type.dart';

class DBProvider implements IEventsRepository {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  static Future<Database> initDB() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(
      documentsDirectory.path,
      DBConstants.database,
    );
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute(
          '''
            CREATE TABLE ${DBConstants.eventTable} (
              ${DBConstants.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
              ${DBConstants.eventTypeId} INTEGER NOT NULL,
              ${DBConstants.eventDate} TEXT NOT NULL,
              ${DBConstants.eventMessage} TEXT NOT NULL,
              ${DBConstants.eventFavorite} INTEGER DEFAULT 0,
              FOREIGN KEY ( ${DBConstants.eventTypeId}) REFERENCES ${DBConstants.eventTypeTable} (${DBConstants.id}) 
                ON DELETE NO ACTION ON UPDATE NO ACTION
            )''',
        );

        await db.execute(
          '''
            CREATE TABLE ${DBConstants.eventTypeTable} (
              ${DBConstants.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
              ${DBConstants.eventTypePin} INTEGER DEFAULT 0,
              ${DBConstants.eventTypeTitle} TEXT NOT NULL,
              ${DBConstants.eventTypeIcon} TEXT DEFAULT Unknown,
              ${DBConstants.eventTypeDate} TEXT NOT NULL
            )''',
        );
      },
    );
  }

  @override
  Future<List<EventType>> fetchEventTypeList() async {
    final db = await database;
    var res = await db.query(
      DBConstants.eventTypeTable,
      orderBy: '${DBConstants.eventTypePin} desc',
    );
    var list = res.isNotEmpty
        ? res
            .map(
              (c) => EventType.fromMap(c),
            )
            .toList()
        : null;
    if (list != null) {
      for (var i = 0; i < list.length; i++) {
        list[i].lastEvent = await fetchLastEvent(list[i]);
      }
    }
    return list;
  }

  @override
  Future<List<Event>> fetchEventsList(
    EventType eventType,
  ) async {
    final db = await database;
    var res = await db.query(
      DBConstants.eventTable,
      where: '${DBConstants.eventTypeId} = ?',
      whereArgs: [eventType.id],
      orderBy: '${DBConstants.eventDate} desc',
    );
    var list = res.isNotEmpty
        ? res
            .map(
              (c) => Event.fromJson(c),
            )
            .toList()
        : null;
    return list;
  }

  Future<Event> fetchLastEvent(
    EventType eventType,
  ) async {
    final db = await database;
    var res = await db.query(
      DBConstants.eventTable,
      where: '${DBConstants.eventTypeId} = ?',
      whereArgs: [eventType.id],
      orderBy: '${DBConstants.eventDate} desc LIMIT 1',
    );
    var item = res.map((e) => Event.fromJson(e));
    if (item.isEmpty) {
      return Event(
        message: 'No Events. Click to create',
        date: null,
      );
    }
    return item.first;
  }

  Future<List<Event>> fetchFavoriteEventsList(
    EventType eventType,
  ) async {
    final db = await database;
    var res = await db.query(
      DBConstants.eventTable,
      where:
          '${DBConstants.eventTypeId} = ? AND ${DBConstants.eventFavorite} = 1',
      whereArgs: [eventType.id],
      orderBy: '${DBConstants.eventDate} desc',
    );
    var list = res.isNotEmpty
        ? res
            .map(
              (c) => Event.fromJson(c),
            )
            .toList()
        : null;
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
      await db.update(
        DBConstants.eventTypeTable,
        eventType.toMap(),
        where: '${DBConstants.id} = ?',
        whereArgs: [eventType.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return eventType;
  }

  @override
  Future<Event> upsertEvent(Event event) async {
    final db = await database;
    if (event.id == null) {
      event.id = await db.insert(
        DBConstants.eventTable,
        event.toJson(),
      );
    } else {
      await db.update(
        DBConstants.eventTable,
        event.toJson(),
        where: '${DBConstants.id} = ?',
        whereArgs: [event.id],
      );
    }
    return event;
  }

  @override
  Future<Event> deleteEvent(Event event) async {
    print(event.id);
    final db = await database;
    await db.delete(
      DBConstants.eventTable,
      where: '${DBConstants.id} = ?',
      whereArgs: [event.id],
    );
    return event;
  }

  @override
  Future<EventType> deleteEventType(EventType eventType) async {
    final db = await database;
    await db.delete(
      DBConstants.eventTypeTable,
      where: '${DBConstants.id} = ?',
      whereArgs: [eventType.id],
    );
    return eventType;
  }
}
