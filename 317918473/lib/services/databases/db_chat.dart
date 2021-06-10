import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/message.dart';

class DBChat {
  static const String table = 'Chat';

  DBChat._();

  static final instance = DBChat._();

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
    final path = join(databasePath, 'chat.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $table( 
            id TEXT PRIMARY KEY,
            category_id TEXT,
            create_at TEXT,
            message TEXT,
            path_image TEXT,
            is_favorite BIT,
            tag TEXT
          )''',
        );
      },
    );
  }

  Future<int> add(Messages messages) async =>
      await _database!.insert(table, messages.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

  Future<List<Messages>> getAllMessages(String categoryId) async {
    final result = await _database!
        .query(table, where: 'category_id = ?', whereArgs: [categoryId]);
    return result.isNotEmpty
        ? result.map((map) => Messages.fromMap(map)).toList()
        : [];
  }

  Future<int> update(Messages messages) async =>
      await _database!.update(table, messages.toMap(),
          where: 'id = ?', whereArgs: [messages.id]);

  Future<int> delete(String id) async =>
      await _database!.delete(table, where: 'id = ?', whereArgs: [id]);

  Future<void> favorite(List<Messages> favorited) async {
    for (var item in favorited) {
      await _database!
          .update(table, item.toMap(), where: 'id = ?', whereArgs: [item.id]);
    }
  }
}
