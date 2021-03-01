import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/event_message.dart';
import '../models/suggestion.dart';

final String tableSuggestion = 'suggestion';
final String columnId = 'id';
final String columnNameOfSuggestion = 'name';
final String columnInfoOfSuggestion = 'info';
final String columnImagePathOfSuggestion = 'imagePath';
final String columnIsPinned = 'isPinned';

final String tableEventMessage = 'eventMessage';
final String columnIdEventMessage = 'id';
final String columnNameOfEventMessageSuggestion = 'name';
final String columnTime = 'time';
final String columnText = 'text';
final String columnIsFavorite = 'isFavorite';
final String columnIsImageMessage = 'isImageMessage';
final String columnImagePath = 'imagePath';
final String columnCategoryImagePath = 'categoryImagePath';
final String columnNameOfCategory = 'nameOfCategory';

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
    var database = openDatabase(join(await getDatabasesPath(), 'suggestion.db'),
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
      $columnNameOfEventMessageSuggestion text not null,
      $columnTime text not null,
      $columnText text not null,
      $columnIsFavorite integer,
      $columnIsImageMessage integer,
      $columnImagePath text not null,
      $columnCategoryImagePath text,
      $columnNameOfCategory text)
      ''');
    });
    return database;
  }

  void insertSuggestion(Suggestion suggestion) async {
    var db = await database;
    db.insert(tableSuggestion, suggestion.toMap());
  }

  Future<int> deleteSuggestion(Suggestion suggestion) async {
    var db = await database;
    return await db.delete(tableSuggestion,
        where: '$columnId = ?', whereArgs: [suggestion.id]);
  }

  Future<int> updateSuggestion(Suggestion suggestion) async {
    var db = await database;
    return await db.update(tableSuggestion, suggestion.toMap(),
        where: '$columnId = ?', whereArgs: [suggestion.id]);
  }

  Future<List<Suggestion>> dbSuggestionsList() async {
    var _suggestionsList = <Suggestion>[];

    var db = await database;
    var dbSuggestionList = await db.query(tableSuggestion);
    for (var element in dbSuggestionList) {
      var suggestion = Suggestion.fromMap(element);
      _suggestionsList.add(suggestion);
    }
    return _suggestionsList;
  }

  void insertEventMessage(EventMessage eventMessage) async {
    var db = await database;
    db.insert(tableEventMessage, eventMessage.toMap());
  }

  Future<int> deleteEventMessage(EventMessage eventMessage) async {
    var db = await database;
    return await db.delete(tableEventMessage,
        where: '$columnId = ?', whereArgs: [eventMessage.id]);
  }

  Future<int> updateEventMessage(EventMessage eventMessage) async {
    var db = await database;
    return await db.update(tableEventMessage, eventMessage.toMap(),
        where: '$columnId = ?', whereArgs: [eventMessage.id]);
  }

  Future<List<EventMessage>> dbEventMessagesList() async {
    var _eventMessagesList = <EventMessage>[];

    var db = await database;
    var dbEventMessagesList = await db.query(tableEventMessage);
    for (var element in dbEventMessagesList) {
      var eventMessage = EventMessage.fromMap(element);
      _eventMessagesList.add(eventMessage);
    }
    return _eventMessagesList;
  }
}
