import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/category.dart';
import '../entity/message.dart';

const String _categoryTable = 'category';
const String _columnCategoryId = 'category_id';
const String _columnTitle = 'title';
const String _columnCategoryIconIndex = 'category_icon_index';
const String _columnNameOfSubTittle = 'sub_tittle_name';

const String _messageTable = 'message';
const String _columnMessageId = 'message_id';
const String _columnCurrentCategoryId = 'current_category_id';
const String _columnText = 'text';
const String _columnTime = 'time';
const String _columnImagePath = 'image_path';
const String _columnEventBookmarkIndex = 'bookmark_index';

class DatabaseProvider {
  static DatabaseProvider? _databaseProvider;
  static Database? _database;

  DatabaseProvider._createInstance();

  Future<Database> get database async {
    return _database ?? await _initDB();
  }

  factory DatabaseProvider() {
    return _databaseProvider ?? DatabaseProvider._createInstance();
  }

  Future<Database> _initDB() async {
    final database = openDatabase(
      join(
        await getDatabasesPath(),
        'chat_journal_database.db',
      ),
      version: 1,
      onCreate: (db, version) {
        db.execute('''
     create table $_categoryTable (
	    $_columnCategoryId integer primary key autoincrement,
      $_columnTitle text not null,
      $_columnNameOfSubTittle text not null,
      $_columnCategoryIconIndex integer
);
      ''');
        db.execute('''
     create table $_messageTable(
      $_columnMessageId integer primary key autoincrement,
      $_columnCurrentCategoryId integer,
      $_columnText text not null,
      $_columnTime text not null,  
      $_columnEventBookmarkIndex integer, 
      $_columnImagePath text  
      )
      ''');
      },
    );
    return database;
  }

  Future<int> insertCategory(Category category) async {
    final db = await database;
    return db.insert(
      _categoryTable,
      category.convertCategoryToMapWithId(),
    );
  }

  Future<int> deleteCategory(Category category) async {
    final db = await database;
    return db.delete(
      _categoryTable,
      where: '$_columnCategoryId = ?',
      whereArgs: [category.categoryId],
    );
  }

  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update(
      _categoryTable,
      category.convertCategoryToMap(),
      where: '$_columnCategoryId = ?',
      whereArgs: [category.categoryId],
    );
  }

  Future<List<Category>> fetchCategoryList() async {
    final db = await database;
    final categoryList = <Category>[];
    final dbCategoryList = await db.query(_categoryTable);
    for (final item in dbCategoryList) {
      final category = Category.fromMap(item);
      categoryList.insert(0, category);
    }
    return categoryList;
  }

  Future<int> insertMessage(Message message) async {
    final db = await database;
    return db.insert(
      _messageTable,
      message.convertMessageToMapWithId(),
    );
  }

  Future<int> deleteMessage(Message message) async {
    final db = await database;
    return await db.delete(
      _messageTable,
      where: '$_columnMessageId = ?',
      whereArgs: [message.messageId],
    );
  }

  Future<int> updateMessage(Message message) async {
    final db = await database;
    return await db.update(
      _messageTable,
      message.convertMessageToMap(),
      where: '$_columnMessageId = ?',
      whereArgs: [message.messageId],
    );
  }

  Future<int> deleteAllMessagesFromCategory(int categoryId) async {
    final db = await database;
    return await db.delete(
      _categoryTable,
      where: '$_columnCategoryId = ?',
      whereArgs: [categoryId],
    );
  }

  Future<List<Message>> fetchMessageList(int categoryId) async {
    final db = await database;
    final messageList = <Message>[];
    var dbMessageList = await db.rawQuery(
      'SELECT * FROM $_messageTable WHERE $_columnCurrentCategoryId = ?',
      [categoryId],
    );
    for (final item in dbMessageList) {
      final event = Message.fromMap(item);
      messageList.insert(0, event);
    }
    return messageList;
  }

  Future<List<Message>> fetchFullMessageList() async {
    final db = await database;
    final messageList = <Message>[];
    final dbCategoryList = await db.query(_messageTable);
    for (final element in dbCategoryList) {
      final message = Message.fromMap(element);
      messageList.insert(0, message);
    }
    return messageList;
  }
}
