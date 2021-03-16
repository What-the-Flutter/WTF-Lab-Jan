import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../repository/pages_repository.dart';
import '../repository/property_message.dart';
import '../repository/property_page.dart';

final String tablePage = 'page';
final String columnIdPage = 'id';
final String columnTitleOfPage = 'title';
final String columnCreationTime = 'creationTime';
final String columnLastModifiedTime = 'lastModifiedTime';
final String columnIsPin = 'isPin';
final String columnIconCodePoint = 'iconCodePoint';

final String tableMessage = 'Message';
final String columnIdMessage = 'id';
final String columnTime = 'time';
final String columnMessage = 'message';
final String columnIconCodePointMessage = 'iconCodePointMessage';
final String columnIdMessagePage = 'idMessagePage';

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
    var database = openDatabase(
      join(await getDatabasesPath(), 'temp11.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute('''
      create table $tablePage(
      $columnIdPage integer primary key autoincrement,
      $columnTitleOfPage text not null,
      $columnCreationTime text not null,
      $columnLastModifiedTime text,
      $columnIconCodePoint integer,
      $columnIsPin integer)
      ''');
        db.insert(tablePage, dialogPages[0].toMap());
        db.insert(tablePage, dialogPages[1].toMap());
        db.insert(tablePage, dialogPages[2].toMap());
        db.execute('''
      create table $tableMessage(
      $columnIdMessage integer primary key autoincrement,
      $columnTime text not null,
      $columnMessage text not null,
      $columnIconCodePointMessage integer,
      $columnIdMessagePage integer)
      ''');
      },
    );
    return database;
  }

  Future<int> insertPage(PropertyPage page) async {
    var db = await database;
    return db.insert(
      tablePage,
      page.toMap(),
    );
  }

  Future<int> deletePage(PropertyPage suggestion) async {
    var db = await database;
    return await db.delete(
      tablePage,
      where: '$columnIdPage = ?',
      whereArgs: [suggestion.id],
    );
  }

  Future<int> updatePage(PropertyPage suggestion) async {
    var db = await database;
    return await db.update(
      tablePage,
      suggestion.toMap(),
      where: '$columnIdPage = ?',
      whereArgs: [suggestion.id],
    );
  }

  Future<List<PropertyPage>> dbPagesList() async {
    var _pagesList = <PropertyPage>[];
    var db = await database;
    var dbPageList = await db.query(tablePage);
    for (var element in dbPageList) {
      var page = PropertyPage.fromMap(element);
      _pagesList.add(page);
    }
    return _pagesList;
  }

  void insertMessage(PropertyMessage message) async {
    var db = await database;
    db.insert(
      tableMessage,
      message.toMap(),
    );
  }

  Future<int> deleteMessage(PropertyMessage message) async {
    var db = await database;
    return await db.delete(
      tableMessage,
      where: '$columnIdMessage = ?',
      whereArgs: [message.id],
    );
  }

  Future<int> updateMessage(PropertyMessage message) async {
    var db = await database;
    return await db.update(
      tableMessage,
      message.toMap(),
      where: '$columnIdMessage = ?',
      whereArgs: [message.id],
    );
  }

  Future<List<PropertyMessage>> dbMessagesList(int index) async {
    var _messagesList = <PropertyMessage>[];
    var db = await database;
    var dbMessagesList = await db.query(tableMessage,
        where: '$columnIdMessagePage = ?', whereArgs: [index]);
    for (var element in dbMessagesList) {
      var message = PropertyMessage.fromMap(element);
      _messagesList.add(message);
    }
    return _messagesList;
  }
}
