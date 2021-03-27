import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/event_message.dart';
import '../models/suggestion.dart';
import '../models/tag.dart';

const String tableSuggestion = 'suggestion';
const String columnId = 'id';
const String columnNameOfSuggestion = 'name';
const String columnInfoOfSuggestion = 'info';
const String columnImagePathOfSuggestion = 'image_path';
const String columnIsPinned = 'is_pinned';

const String tableEventMessage = 'event_message';
const String columnIdEventMessage = 'id';
const String columnIdOfSuggestion = 'id_of_suggestion';
const String columnNameOfSuggestionForEvMsg = 'name_of_suggestion';
const String columnTime = 'time';
const String columnText = 'text';
const String columnIsFavorite = 'is_favorite';
const String columnIsImageMessage = 'is_image_message';
const String columnImagePath = 'image_path';
const String columnCategoryImagePath = 'category_image_path';
const String columnNameOfCategory = 'name_of_category';

const String tableTag = 'tag';
const String columnIdTag = 'id';
const String columnTagText = 'tag_text';

class DBHelper {
  static Database _database;
  static DBHelper _suggestionHelper;

  DBHelper._createInstance();

  factory DBHelper() {
    _suggestionHelper ??= DBHelper._createInstance();
    return _suggestionHelper;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    final database = openDatabase(
        join(await getDatabasesPath(), 'suggestion.db'),
        version: 1, onCreate: (db, version) {
      db.execute('''
      create table $tableSuggestion(
      $columnId integer primary key autoincrement,
      $columnNameOfSuggestion text not null,
      $columnInfoOfSuggestion text not null,
      $columnImagePathOfSuggestion text not null,
      $columnIsPinned integer)
      ''');
      db.execute('''
      create table $tableEventMessage(
      $columnIdEventMessage integer primary key autoincrement,
      $columnIdOfSuggestion integer,
      $columnNameOfSuggestionForEvMsg text not null,
      $columnTime text not null,
      $columnText text not null,
      $columnIsFavorite integer,
      $columnIsImageMessage integer,
      $columnImagePath text not null,
      $columnCategoryImagePath text,
      $columnNameOfCategory text)
      ''');
      db.execute('''
      create table $tableTag(
      $columnIdTag integer primary key autoincrement,
      $columnTagText text)
      ''');
    });
    return database;
  }

  Future<int> insertSuggestion(Suggestion suggestion) async {
    final db = await database;
    return db.insert(
      tableSuggestion,
      suggestion.insertToMap(),
    );
  }

  Future<int> deleteSuggestion(Suggestion suggestion) async {
    final db = await database;
    db.rawDelete(
      'DELETE FROM $tableEventMessage WHERE $columnIdOfSuggestion = ? ',
      [suggestion.id],
    );
    return await db.delete(
      tableSuggestion,
      where: '$columnId = ?',
      whereArgs: [suggestion.id],
    );
  }

  Future<int> updateSuggestion(Suggestion suggestion) async {
    final db = await database;
    return await db.update(
      tableSuggestion,
      suggestion.toMap(),
      where: '$columnId = ?',
      whereArgs: [suggestion.id],
    );
  }

  Future<List<Suggestion>> dbSuggestionsList() async {
    final suggestionsList = <Suggestion>[];

    final db = await database;
    final dbSuggestionList = await db.query(tableSuggestion);
    for (final element in dbSuggestionList) {
      final suggestion = Suggestion.fromMap(element);
      suggestionsList.add(suggestion);
    }
    return suggestionsList;
  }

  void updateEventMessageListOfSuggestion(Suggestion suggestion) async {
    final db = await database;
    var dbEventMessagesList = await db.rawQuery(
      'SELECT * FROM $tableEventMessage WHERE $columnIdOfSuggestion = ?',
      [suggestion.id],
    );
    for (final element in dbEventMessagesList) {
      final eventMessage = EventMessage.fromMap(element);
      eventMessage.nameOfSuggestion = suggestion.nameOfSuggestion;
      updateEventMessage(eventMessage);
    }
  }

  void insertEventMessage(EventMessage eventMessage) async {
    final db = await database;
    db.insert(
      tableEventMessage,
      eventMessage.toMap(),
    );
  }

  Future<int> deleteEventMessage(EventMessage eventMessage) async {
    final db = await database;
    return await db.delete(
      tableEventMessage,
      where: '$columnId = ?',
      whereArgs: [eventMessage.id],
    );
  }

  Future<int> updateEventMessage(EventMessage eventMessage) async {
    final db = await database;
    return await db.update(
      tableEventMessage,
      eventMessage.toMap(),
      where: '$columnId = ?',
      whereArgs: [eventMessage.id],
    );
  }

  Future<List<EventMessage>> dbEventMessagesList() async {
    final eventMessagesList = <EventMessage>[];

    final db = await database;
    final dbEventMessagesList = await db.query(tableEventMessage);
    for (final element in dbEventMessagesList) {
      final eventMessage = EventMessage.fromMap(element);
      eventMessagesList.add(eventMessage);
    }
    return eventMessagesList;
  }

  Future<List<EventMessage>> dbEventMessagesListForEventScreen(
      int suggestionId) async {
    final eventMessagesList = <EventMessage>[];

    final db = await database;
    var dbEventMessagesList = await db.rawQuery(
      'SELECT * FROM $tableEventMessage WHERE $columnIdOfSuggestion = ?',
      [suggestionId],
    );
    for (final element in dbEventMessagesList) {
      final eventMessage = EventMessage.fromMap(element);
      eventMessagesList.insert(0, eventMessage);
    }
    return eventMessagesList;
  }

  Future<List<Tag>> dbTagList() async {
    final tagList = <Tag>[];

    final db = await database;
    final dbTagList = await db.query(tableTag);
    for (final element in dbTagList) {
      final tag = Tag.fromMap(element);
      tagList.add(tag);
    }
    return tagList;
  }

  Future<int> insertTag(Tag tag) async {
    final db = await database;
    return db.insert(
      tableTag,
      tag.toMap(),
    );
  }

  Future<int> deleteTag(Tag tag) async {
    final db = await database;
    return await db.delete(
      tableTag,
      where: '$columnIdTag = ?',
      whereArgs: [tag.id],
    );
  }
}
