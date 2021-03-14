import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalDatabaseProvider {
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    await _initDatabase();
    return _database;
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(
        await getDatabasesPath(),
        'chat_journal.db',
      ),
      onCreate: (db, version) {
        db.execute('CREATE TABLE categories('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'name STRING,'
            'iconCodePoint INTEGER,'
            'createDateTime INTEGER,'
            'isPinned INTEGER'
            ');');
        db.execute('CREATE TABLE records('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'message STRING,'
            'imageUri STRING,'
            'createDateTime INTEGER,'
            'categoryId INTEGER,'
            'isSelected INTEGER,'
            'isFavorite INTEGER'
            ');');
      },
      version: 1,
    );
  }
}
