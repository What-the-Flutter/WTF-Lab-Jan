import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/category_model.dart';
import 'db_data.dart';

import 'db_models/category_db_model.dart';
import 'db_models/note_db_model.dart';

class DbProvider {
  DbProvider._();

  static final DbProvider dbProvider = DbProvider._();
  static Database? _database;
  final String categoriesTable = 'categories';
  final String notesTable = 'notes';
  final String categoryNoteTable = 'category_note';
  final String noteTagsTable = 'tags';

  static const notePrefix = 'note_';
  static const categoryPrefix = 'category_';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    // await deleteDatabase(join(await getDatabasesPath(), 'note_database.db'));
    return await openDatabase(
      join(await getDatabasesPath(), 'note_database.db'),
      version: 2,
      onCreate: (db, version) async {
        db.execute(
          'CREATE TABLE $categoriesTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, '
          'icon INTEGER , priority INTEGER, is_default BOOL);',
        );
        db.execute(
          'CREATE TABLE $notesTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, created INTEGER, '
          'has_star BOOL, updated INTEGER, text TEXT, image TEXT , note_tag_id INTEGER);',
        );

        db.execute(
          'CREATE TABLE $categoryNoteTable(category_id INTEGER NOT NULL, note_id INTEGER NOT NULL, '
          'FOREIGN KEY (category_id) REFERENCES $categoriesTable(id) '
          'ON DELETE CASCADE ON UPDATE NO ACTION, '
          'FOREIGN KEY (note_id) REFERENCES $notesTable(id) ON DELETE CASCADE ON UPDATE NO ACTION );',
        );

        db.execute(
          'CREATE TABLE $noteTagsTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT UNIQUE, icon INTEGER );',
        );

        await _insertCategories(db, defaultCategoriesData);
        await _insertCategories(db, categoriesData);
      },
    );
  }

  Future<int> insertCategory(CategoryDbModel category) async {
    final db = await database;
    return db.insert(
      categoriesTable,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _insertCategories(
    Database db,
    List<CategoryDbModel> categories,
  ) async {
    final batch = db.batch();
    for (final category in categories) {
      batch.insert(
        categoriesTable,
        category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<void> insertCategories(List<CategoryDbModel> categories) async {
    final db = await database;
    await _insertCategories(db, categories);
  }

  Future<int> updateCategory(CategoryDbModel category) async {
    final db = await database;
    return db.update(categoriesTable, category.toMap(),
        where: 'id = ?', whereArgs: [category.id]);
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return db.delete(categoriesTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<CategoryDbModel>> categories({bool isDefault = false}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      categoriesTable,
      where: 'is_default = ?',
      whereArgs: [isDefault ? 1 : 0],
    );
    return List.generate(maps.length, (i) => CategoryDbModel.fromMap(maps[i]));
  }

  Future<int> insertNote(int categoryId, NoteDbModel note) async {
    final db = await database;
    final noteId = await db.insert(
      notesTable,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.insert(
        categoryNoteTable, {'category_id': categoryId, 'note_id': noteId});
    return noteId;
  }

  Future<int> updateNote(NoteDbModel note) async {
    final db = await database;
    return db.update(
      notesTable,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<bool> updateNoteCategories(
      int categoryId, List<NoteDbModel> notes) async {
    final db = await database;
    final batch = db.batch();
    for (final note in notes) {
      batch.update(
        categoryNoteTable,
        {
          'category_id': categoryId,
          'note_id': note.id,
        },
        where: 'note_id = ?',
        whereArgs: [note.id],
      );
    }
    final result = await batch.commit();
    return !result.any((element) => element is DatabaseException);
  }

  // returns true if all update transactions succeeded
  Future<bool> updateNotes(List<NoteDbModel> notes) async {
    final db = await database;
    final batch = db.batch();
    for (final note in notes) {
      batch.update(
        notesTable,
        note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
      );
    }
    final result = await batch.commit();
    return !result.any((element) => element is DatabaseException);
  }

  Future<bool> deleteNotes(List<NoteDbModel> notes) async {
    final db = await database;
    final batch = db.batch();
    for (final note in notes) {
      batch.delete(
        notesTable,
        where: 'id = ?',
        whereArgs: [note.id],
      );
    }
    final result = await batch.commit();
    return !result.any((element) => element is DatabaseException);
  }

  Future<List<NoteDbModel>> notesFor(Category category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM $notesTable '
      'INNER JOIN $categoryNoteTable ON $notesTable.id = $categoryNoteTable.note_id '
      'WHERE $categoryNoteTable.category_id = ${category.id}',
    );
    return List.generate(maps.length, (i) => NoteDbModel.fromMap(maps[i]));
  }
}
