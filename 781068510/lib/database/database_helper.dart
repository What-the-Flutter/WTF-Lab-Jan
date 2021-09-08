import 'package:notes/models/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _dbName = 'database.db';
  static final _dbVersion = 1;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initiateDatabase();
    return _database!;
  }

  Future _initiateDatabase() async {
    var directory = await getDatabasesPath();
    var path = join(directory, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final stringType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $pagesTable (
    ${PagesFields.isPinned} $boolType,
    ${PagesFields.isPinned} $boolType,
    ${PagesFields.title} $stringType,
    ${PagesFields.lastMessage} $stringType,
    ${PagesFields.createDate} $stringType,
    ${PagesFields.lastEditDate} $stringType,
    ''');
  }

  Future create(PageCategoryInfo page) async{
    final db = await instance.database;
    final id = await db.insert(pagesTable, page.toJson());
    return page.copyWith();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
