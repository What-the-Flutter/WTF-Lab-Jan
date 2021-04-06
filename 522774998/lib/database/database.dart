import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../properties/property_message.dart';
import '../properties/property_page.dart';

import '../repository/pages_repository.dart';

final String tablePage = 'table_page';
final String columnIdPage = 'id';
final String columnTitleOfPage = 'title';
final String columnCreationTime = 'creation_time';
final String columnLastModifiedTime = 'last_modified_time';
final String columnIsPin = 'is_pin';
final String columnIconIndex = 'icon_index';

final String tableMessage = 'table_message';
final String columnIdMessage = 'id';
final String columnTime = 'time';
final String columnData = 'data';
final String columnIconCodePointMessage = 'icon_code_point_message';
final String columnIdMessagePage = 'id_message_page';
final String columnIsSelected = 'is_selected';
final String columnIsBookmark = 'is_bookmark';
final String columnIsVisible = 'is_visible';

class DBHelper {
  final Database database;

  DBHelper({this.database});

  static Future<Database> initializeDatabase() async {
    var database = openDatabase(
      join(await getDatabasesPath(), 'temp21.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute('''
      create table $tablePage(
      $columnIdPage integer primary key autoincrement,
      $columnTitleOfPage text not null,
      $columnCreationTime text not null,
      $columnLastModifiedTime text,
      $columnIconIndex integer,
      $columnIsPin integer)
      ''');
        db.insert(tablePage, dialogPages[0].toMap());
        db.insert(tablePage, dialogPages[1].toMap());
        db.insert(tablePage, dialogPages[2].toMap());
        db.execute('''
      create table $tableMessage(
      $columnIdMessage integer primary key autoincrement,
      $columnTime text not null,
      $columnData text not null,
      $columnIconCodePointMessage integer,
      $columnIdMessagePage integer,
      $columnIsSelected integer,
      $columnIsBookmark integer,
      $columnIsVisible integer)
      ''');
      },
    );
    return database;
  }

  Future<void> insertPage(PropertyPage page) async {
    final db = await database;
    await db.insert(
      tablePage,
      page.toMap(),
    );
  }

  Future<void> deletePage(int id) async {
    final db = await database;
    return await db.delete(
      tablePage,
      where: '$columnIdPage = ?',
      whereArgs: [id],
    );
  }

  Future<void> updatePage(PropertyPage suggestion) async {
    final db = await database;
    await db.update(
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

  Future<void> insertMessage(PropertyMessage message) async {
    final db = await database;
    await db.insert(
      tableMessage,
      message.toMap(),
    );
  }

  Future<void> deleteMessage(int id) async {
    final db = await database;
    await db.delete(
      tableMessage,
      where: '$columnIdMessage = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteMessages(int idMessagePage) async {
    final db = await database;
    await db.delete(
      tableMessage,
      where: '$columnIdMessage = ?',
      whereArgs: [idMessagePage],
    );
  }

  Future<void> updateMessage(PropertyMessage message) async {
    final db = await database;
    return await db.update(
      tableMessage,
      message.toMap(),
      where: '$columnIdMessage = ?',
      whereArgs: [message.id],
    );
  }

  Future<List<PropertyMessage>> dbMessagesList(int idMessagePage) async {
    var _messagesList = <PropertyMessage>[];
    final db = await database;
    final dbMessagesList = await db.query(tableMessage,
        where: '$columnIdMessagePage = ?', whereArgs: [idMessagePage]);
    for (final element in dbMessagesList) {
      final message = PropertyMessage.fromMap(element);
      _messagesList.add(message);
    }
    return _messagesList;
  }

  Future<List<PropertyMessage>> dbMessagesListFromAllPages() async {
    var _messagesList = <PropertyMessage>[];
    final db = await database;
    final dbMessagesList = await db.query(tableMessage);
    for (final element in dbMessagesList) {
      final message = PropertyMessage.fromMap(element);
      _messagesList.add(message);
    }
    return _messagesList;
  }
}
