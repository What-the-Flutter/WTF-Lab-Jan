import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/category.dart';
import '../../models/message.dart';

const isFavorite = 'is_favorite';
const isSelected = 'is_selected';
const isEdit = 'is_edit';
const categoryId = 'category_id';

class DBProvider {
  static const String categoryTable = 'Category';
  static const String chatTable = 'Chat';

  DBProvider._();

  static final instance = DBProvider._();

  static Database? _database;

  static Future<void> init() async {
    if (_database != null) {
      return;
    }
    try {
      _database = await initDB();
    } catch (e) {
      print(e);
    }
  }

  static Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'category.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $categoryTable( 
            id TEXT PRIMARY KEY,
            assert_image TEXT,
            description TEXT,
            title TEXT,
            categories TEXT,
            pinned BIT
          )''',
        );
        await db.execute(
          '''CREATE TABLE $chatTable( 
            id TEXT PRIMARY KEY,
            $categoryId TEXT,
            create_at TEXT,
            message TEXT,
            path_image TEXT,
            $isSelected BIT,
            $isFavorite BIT,
            $isEdit BIT,
            tag TEXT
          )''',
        );
      },
    );
  }

  Future<int> addCategory(Category category) async =>
      await _database!.insert(categoryTable, category.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

  Future<List<Category>> getAllCategories() async {
    print('categories');
    final result = await _database!.query(categoryTable);
    return result.isNotEmpty
        ? result.map((map) => Category.fromMap(map)).toList()
        : [];
  }

  Future<int> updateCategory(Category category) async =>
      await _database!.update(categoryTable, category.toMap(),
          where: 'id = ?', whereArgs: [category.id]);

  Future<int> deleteCategory(String id) async =>
      await _database!.delete(categoryTable, where: 'id = ?', whereArgs: [id]);

  Future<int> pinCategory(Category pinned) async =>
      await _database!.update(categoryTable, pinned.toMap(),
          where: 'id = ?', whereArgs: [pinned.id]);

  Future<int> addMessage(Messages messages) async =>
      await _database!.insert(chatTable, messages.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

  Future<List<Messages>> getAllMessages(String categoryID) async {
    final result = await _database!
        .query(chatTable, where: '$categoryId = ?', whereArgs: [categoryID]);
    return result.isNotEmpty
        ? result.map((map) => Messages.fromMap(map)).toList()
        : [];
  }

  Future<int> updateMessage(Messages messages) async =>
      await _database!.update(chatTable, messages.toMap(),
          where: 'id = ?', whereArgs: [messages.id]);

  Future<void> deleteMessage() async {
    await _database!
        .rawDelete('DELETE FROM $chatTable WHERE $isSelected = ?', ['1']);
  }

  Future<void> addOrRemoveMessageToFavorite() async {
    await _database!.rawUpdate(
        'UPDATE $chatTable SET $isFavorite = CASE WHEN $isFavorite = 1 THEN 0 ELSE 1 END, $isSelected = ? WHERE $isSelected = ?',
        ['0', '1']);
  }

  Future<void> unselectMessages() async {
    await _database!.rawUpdate('UPDATE $chatTable SET $isSelected = ?', ['0']);
  }

  Future<void> messageToAnotherCategory(String chatId) async {
    await _database!.rawUpdate(
        'UPDATE $chatTable SET $categoryId = ?, $isSelected = ? WHERE $isSelected = ?',
        [chatId, '0', '1']);
  }
}
