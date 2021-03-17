import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../repository/pages_repository.dart';
import '../repository/property_message.dart';
import '../repository/property_page.dart';

final String tablePage = 'table_page';
final String columnIdPage = 'id';
final String columnTitleOfPage = 'title';
final String columnCreationTime = 'creation_time';
final String columnLastModifiedTime = 'last_modified_time';
final String columnIsPin = 'is_pin';
final String columnIconCodePoint = 'icon_code_point';

final String tableMessage = 'table_message';
final String columnIdMessage = 'id';
final String columnTime = 'time';
final String columnMessage = 'message';
final String columnIconCodePointMessage = 'icon_code_point_message';
final String columnIdMessagePage = 'id_message_page';

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
      join(await getDatabasesPath(), 'chat_journal_app.db'),
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
    final db = await database;
    return db.insert(
      tablePage,
      page.toMap(),
    );
  }

  Future<int> deletePage(PropertyPage suggestion) async {
    final db = await database;
    return await db.delete(
      tablePage,
      where: '$columnIdPage = ?',
      whereArgs: [suggestion.id],
    );
  }

  Future<int> updatePage(PropertyPage suggestion) async {
    final db = await database;
    return await db.update(
      tablePage,
      suggestion.toMap(),
      where: '$columnIdPage = ?',
      whereArgs: [suggestion.id],
    );
  }

  Future<List<PropertyPage>> dbPagesList() async {
    var _pagesList = <PropertyPage>[];
    final db = await database;
    final dbPageList = await db.query(tablePage);
    for (final element in dbPageList) {
      final page = PropertyPage.fromMap(element);
      _pagesList.add(page);
    }
    return _pagesList;
  }
  
  void insertMessage(PropertyMessage message) async {
    final db = await database;
    db.insert(
      tableMessage,
      message.toMap(),
    );
  }

  Future<int> deleteMessage(PropertyMessage message) async {
    final db = await database;
    return await db.delete(
      tableMessage,
      where: '$columnIdMessage = ?',
      whereArgs: [message.id],
    );
  }

  Future<int> updateMessage(PropertyMessage message) async {
    final db = await database;
    return await db.update(
      tableMessage,
      message.toMap(),
      where: '$columnIdMessage = ?',
      whereArgs: [message.id],
    );
  }

  Future<List<PropertyMessage>> dbMessagesList(int index) async {
    var _messagesList = <PropertyMessage>[];
    final db = await database;
    final dbMessagesList = await db.query(tableMessage,
        where: '$columnIdMessagePage = ?', whereArgs: [index]);
    for (final element in dbMessagesList) {
      final message = PropertyMessage.fromMap(element);
      _messagesList.add(message);
    }
    return _messagesList;
  }
}
