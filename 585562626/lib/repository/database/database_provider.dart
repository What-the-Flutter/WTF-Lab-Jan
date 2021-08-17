import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/category.dart';
import 'database_data.dart';
import 'models/category.dart';
import 'models/note.dart';
import 'models/tag.dart';

class DbProvider {
  DbProvider._();

  static final DbProvider dbProvider = DbProvider._();
  static Database? _database;
  final String categoriesTable = 'categories';
  final String notesTable = 'notes';
  final String categoryNoteTable = 'category_note';
  final String tagsTable = 'tags';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'note_database.db'), version: 2,
        onCreate: (db, version) async {
      db.execute(
        'CREATE TABLE $categoriesTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, '
        'color INTEGER, image TEXT, priority INTEGER, isDefault BOOL);',
      );
      db.execute(
        'CREATE TABLE $notesTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, created INTEGER, '
        'direction INTEGER, hasStar BOOL, updated INTEGER, text TEXT, image TEXT);',
      );
      db.execute(
        'CREATE TABLE $categoryNoteTable(category_id INTEGER NOT NULL, note_id INTEGER NOT NULL, '
        'FOREIGN KEY (category_id) REFERENCES $categoriesTable(id) '
        'ON DELETE CASCADE ON UPDATE NO ACTION, '
        'FOREIGN KEY (note_id) REFERENCES $notesTable(id) ON DELETE CASCADE ON UPDATE NO ACTION );',
      );
      await _insertCategories(db, defaultCategoriesData);
      await _insertCategories(db, categoriesData);
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < newVersion) {
        await db.execute(
          'CREATE TABLE $tagsTable(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT UNIQUE);',
        );
      }
    });
  }

  Future<void> insertCategory(DbCategory category) async {
    final db = await database;
    await db.insert(
      categoriesTable,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _insertCategories(Database db, List<DbCategory> categories) async {
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

  Future<void> insertCategories(List<DbCategory> categories) async {
    final db = await database;
    await _insertCategories(db, categories);
  }

  Future<void> updateCategory(DbCategory category) async {
    final db = await database;
    await db.update(categoriesTable, category.toMap(), where: 'id = ?', whereArgs: [category.id]);
  }

  Future<void> deleteCategory(int id) async {
    final db = await database;
    await db.delete(categoriesTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<DbCategory>> categories({bool isDefault = false}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      categoriesTable,
      where: 'isDefault = ?',
      whereArgs: [isDefault ? 1 : 0],
    );
    return List.generate(maps.length, (i) => DbCategory.fromMap(maps[i]));
  }

  Future<void> insertNote(int categoryId, DbNote note) async {
    final db = await database;
    final noteId = await db.insert(
      notesTable,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.insert(categoryNoteTable, {'category_id': categoryId, 'note_id': noteId});
  }

  Future<void> updateNoteCategory(int categoryId, int noteId) async {
    final db = await database;
    await db.update(
      categoryNoteTable,
      {'category_id': categoryId, 'note_id': noteId},
      where: 'note_id = ?',
      whereArgs: [noteId],
    );
  }

  Future<void> updateNote(DbNote note) async {
    final db = await database;
    await db.update(notesTable, note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> updateNotes(List<DbNote> notes) async {
    final db = await database;
    final batch = db.batch();
    for (final note in notes) {
      batch.update(notesTable, note.toMap(), where: 'id = ?', whereArgs: [note.id]);
    }
    await batch.commit();
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete(notesTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteNotes(List<DbNote> notes) async {
    final db = await database;
    final batch = db.batch();
    for (final note in notes) {
      batch.delete(notesTable, where: 'id = ?', whereArgs: [note.id]);
    }
    await batch.commit();
  }

  Future<List<DbNote>> notes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(notesTable);
    return List.generate(maps.length, (i) => DbNote.fromMap(maps[i]));
  }

  Future<List<DbNote>> notesFor(Category category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM $notesTable '
        'INNER JOIN $categoryNoteTable ON $notesTable.id = $categoryNoteTable.note_id '
        'WHERE $categoryNoteTable.category_id = ${category.id}');
    return List.generate(maps.length, (i) => DbNote.fromMap(maps[i]));
  }

  Future<List<DbNote>> starredNotes(Category category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM $notesTable '
        'INNER JOIN $categoryNoteTable ON $notesTable.id = $categoryNoteTable.note_id '
        'WHERE $categoryNoteTable.category_id = ${category.id} AND $notesTable.hasStar = 1');
    return List.generate(maps.length, (i) => DbNote.fromMap(maps[i]));
  }

  Future<void> insertTag(DbTag tag) async {
    final db = await database;
    try {
      await db.insert(tagsTable, tag.toMap());
    } catch (e) {
      print('insertTag Exception: $e');
    }
  }

  Future<List<DbTag>> tags() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tagsTable);
    return List.generate(maps.length, (i) => DbTag.fromMap(maps[i]));
  }
}
