import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../pages/entity/category.dart';
import '../pages/entity/message.dart';

const String categoryTable = 'category';
const String columnCategoryId = 'category_id';
const String columnTitle = 'title';
const String columnCategoryIconIndex = 'category_icon_index';
const String columnNameOfSubTittle = 'sub_tittle_name';

const String messageTable = 'message';
const String columnMessageId = 'message_id';
const String columnCurrentCategoryId = 'current_category_id';
const String columnText = 'text';
const String columnTime = 'time';
const String columnMessageIconIndex = 'category_icon_index';

class DatabaseProvider {
  static DatabaseProvider? _databaseProvider;
  static Database? _database;

  DatabaseProvider._createInstance();

  Future<Database> get database async {
    return _database ?? await initDB();
  }

  factory DatabaseProvider() {
    return _databaseProvider ?? DatabaseProvider._createInstance();
  }

  Future<Database> initDB() async {
    final database = openDatabase(
      join(
        await getDatabasesPath(),
        'chat_journal_database.db',
      ),
      version: 1,
      onCreate: (db, version) {
        db.execute('''
     create table $categoryTable (
	   $columnCategoryId integer primary key autoincrement,
      $columnTitle text not null,
      $columnNameOfSubTittle text not null,
      $columnCategoryIconIndex integer
);
      ''');
        db.execute('''
     create table $messageTable(
      $columnMessageId integer primary key autoincrement,
      $columnCurrentCategoryId integer,
      $columnText text not null,
      $columnTime text not null,
      $columnMessageIconIndex integer
      )
      ''');
      },
    );
    return database;
  }

  Future<int> insertCategory(Category category) async {
    final db = await database;
    print('1');
    return db.insert(
      categoryTable,
      category.convertCategoryToMapWithId(),
    );
  }

  Future<int> deleteCategory(Category category) async {
    print('2');
    final db = await database;
    return db.delete(
      categoryTable,
      where: '$columnCategoryId = ?',
      whereArgs: [category.categoryId],
    );
  }

  Future<int> updateCategory(Category category) async {
    print('3');
    final db = await database;
    return await db.update(
      categoryTable,
      category.convertCategoryToMap(),
      where: '$columnCategoryId = ?',
      whereArgs: [category.categoryId],
    );
  }

  Future<List<Category>> downloadCategoryList() async {
    print('4');
    final db = await database;
    final categoryList = <Category>[];
    final dbCategoryList = await db.query(categoryTable);
    for (final item in dbCategoryList) {
      final category = Category.fromMap(item);
      categoryList.insert(0, category);
    }
    return categoryList;
  }

  Future<int> insertMessage(Message message) async {
    print('5');
    final db = await database;
    return db.insert(
      messageTable,
      message.convertMessageToMapWithId(),
    );
  }

  Future<int> deleteMessage(Message message) async {
    print('6');
    final db = await database;
    return await db.delete(
      messageTable,
      where: '$columnMessageId = ?',
      whereArgs: [message.messageId],
    );
  }

  Future<int> updateMessage(Message message) async {
    print('7');
    final db = await database;
    return await db.update(
      messageTable,
      message.convertMessageToMap(),
      where: '$columnMessageId = ?',
      whereArgs: [message.messageId],
    );
  }

  Future<List<Message>> downloadMessageList(int categoryId) async {
    print('8');
    final db = await database;
    final messageList = <Message>[];
    var dbMessageList = await db.rawQuery(
      'SELECT * FROM $messageTable WHERE $columnCurrentCategoryId = ?',
      [categoryId],
    );
    for (final item in dbMessageList) {
      final event = Message.fromMap(item);
      messageList.insert(0, event);
    }
    return messageList;
  }

  Future<int> deleteAllMessagesFromCategory(int categoryId) async {
    print('9');
    final db = await database;
    return await db.delete(
      categoryTable,
      where: '$columnCategoryId = ?',
      whereArgs: [categoryId],
    );
  }
}
