import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/category.dart';

class DBCategory {
  static const String table = 'Category';

  DBCategory._();

  static final instance = DBCategory._();

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
          '''CREATE TABLE $table( 
            id TEXT PRIMARY KEY,
            assert_image TEXT,
            description TEXT,
            title TEXT,
            categories TEXT,
            pinned BIT
          )''',
        );
      },
    );
  }

  Future<int> add(Category category) async =>
      await _database!.insert(table, category.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

  Future<List<Category>> getAllCategories() async {
    print('categories');
    final result = await _database!.query(table);
    return result.isNotEmpty
        ? result.map((map) => Category.fromMap(map)).toList()
        : [];
  }

  Future<int> update(Category category) async =>
      await _database!.update(table, category.toMap(),
          where: 'id = ?', whereArgs: [category.id]);

  Future<int> delete(String id) async =>
      await _database!.delete(table, where: 'id = ?', whereArgs: [id]);

  Future<int> pin(Category pinned) async => await _database!
      .update(table, pinned.toMap(), where: 'id = ?', whereArgs: [pinned.id]);
}
