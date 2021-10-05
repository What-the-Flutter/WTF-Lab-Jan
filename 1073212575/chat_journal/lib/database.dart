import 'dart:core';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/events_model.dart';

const String tableMessages = 'event_message';
const String columnMessageId = 'message_id';
const String columnPageId = 'page_id';
const String columnContent = 'content';
const String columnDate = 'date';
const String columnIcon = 'icon';
const String columnIsMarked = 'is_marked';

const String tablePages = 'event_pages';
const String columnName = 'name';
const String columnIsFixed = 'is_fixed';
const String rowId = 'rowid';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'chat_journal_db.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (db, version) async {
      await db.execute(
          //'PRAGMA foreign_keys=on;'
          'CREATE TABLE $tablePages('
          '$columnPageId TEXT PRIMARY KEY,'
          '$columnName TEXT,'
          '$columnDate INTEGER,'
          '$columnIcon TEXT,'
          '$columnIsFixed INTEGER'
          ');');
      await db.execute('CREATE TABLE $tableMessages('
          '$columnMessageId TEXT PRIMARY KEY,'
          '$columnPageId TEXT, '
          //'FOREIGN KEY ($columnPageId) REFERENCES $tablePages($columnPageId),'
          '$columnContent TEXT,'
          '$columnDate INTEGER,'
          '$columnIcon TEXT,'
          '$columnIsMarked INTEGER'
          ');');
    });
  }

  Future<void> insertMessage(EventMessage eventMessage) async {
    final db = await database;
    await db!.insert(
      tableMessages,
      eventMessage.toMap(),
    );
  }

  Future<void> updateMessage(EventMessage eventMessage) async {
    final db = await database;
    await db!.update(
      tableMessages,
      eventMessage.toMap(),
      where: '$columnMessageId = ?',
      whereArgs: [eventMessage.id],
    );
  }

  Future<void> deleteMessage(String messageId) async {
    final db = await database;
    await db!.delete(
      tableMessages,
      where: '$columnMessageId = ?',
      whereArgs: [messageId],
    );
  }

  Future<int?> messageRowId(EventPages eventPage) async {
    final db = await database;
    final result = await db!.rawQuery(
        'SELECT rowid FROM $tablePages where $columnDate = "${eventPage.date}"');
    final id = Sqflite.firstIntValue(result);
    print('id = $id');
    return id;
  }

  Future<List<EventMessage>> messagesList(String eventPageId) async {
    final db = await database;
    db!.execute('VACUUM;');
    var messageList = <EventMessage>[];
    final messagesList =
        await db.query('$tableMessages where $columnPageId = $eventPageId');
    for (final element in messagesList) {
      final note = EventMessage.fromMap(element);
      messageList.insert(0, note);
    }
    return messageList.reversed.toList();
  }

  Future<List<EventMessage>> markedMessagesList(String eventPageId) async {
    final db = await database;
    db!.execute('VACUUM;');
    var messageList = <EventMessage>[];
    final messagesList = await db.query(
        '$tableMessages where $columnPageId = $eventPageId and $columnIsMarked = 1');
    for (final element in messagesList) {
      final note = EventMessage.fromMap(element);
      messageList.insert(0, note);
    }
    return messageList.reversed.toList();
  }

  Future<List<EventMessage>> searchMessagesList(
    String eventPageId,
    String searchText,
  ) async {
    final db = await database;
    db!.execute('VACUUM;');
    var messageList = <EventMessage>[];
    final messagesList = await db.query(
        '$tableMessages where $columnPageId = $eventPageId and $columnContent like "%$searchText%"');
    for (final element in messagesList) {
      final note = EventMessage.fromMap(element);
      messageList.insert(0, note);
    }
    return messageList.reversed.toList();
  }

  Future<int> insertPage(EventPages eventPage) async {
    final db = await database;
    final insertedPageId = await db!.insert(
      tablePages,
      eventPage.toMap(),
    );
    return insertedPageId;
  }

  Future<void> updatePage(EventPages eventPage) async {
    final db = await database;
    db!.execute('VACUUM;');
    await db.update(
      tablePages,
      eventPage.toMap(),
      where: '$columnPageId = ?',
      whereArgs: [eventPage.id],
    );
  }

  Future<void> deletePage(String deletePageId) async {
    final db = await database;
    db!.execute('VACUUM;');
    await db.delete(
      tablePages,
      where: '$columnPageId = ?',
      whereArgs: [deletePageId],
    );
    await db.delete(
      tableMessages,
      where: '$columnPageId = ?',
      whereArgs: [deletePageId],
    );
    print('deletePageId = $deletePageId');
  }

  Future<List<EventPages>> eventPagesList() async {
    final db = await database;
    db!.execute('VACUUM;');
    final eventList = <EventPages>[];
    final dbPagesList = await db.query('$tablePages order by is_fixed;');
    for (final element in dbPagesList) {
      final note = EventPages.fromMap(element);
      eventList.insert(0, note);
    }
    return eventList;
  }


}
