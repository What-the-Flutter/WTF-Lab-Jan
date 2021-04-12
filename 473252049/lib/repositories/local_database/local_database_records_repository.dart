import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/record.dart';
import '../records_repository.dart';
import 'provider/local_database_provider.dart';

class LocalDatabaseRecordsRepository extends LocalDatabaseProvider
    implements RecordsRepository {
  @override
  Future<Record> delete(int id) async {
    final record = getById(id);
    await (await database).delete(
      'records',
      where: 'id = ?',
      whereArgs: [id],
    );
    return record;
  }

  @override
  Future<List<Record>> getAll() async {
    return (await (await database).query(
      'records',
      orderBy: 'createDateTime DESC',
    ))
        .map((e) => Record.fromMap(e))
        .toList();
  }

  @override
  Future<void> insert(Record record) async {
    (await database).insert(
      'records',
      record.toMap(),
    );
  }

  @override
  Future<List<Record>> getAllFromCategory({
    @required int categoryId,
  }) async {
    return (await (await database).query(
      'records',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
      orderBy: 'createDateTime DESC',
    ))
        .map((e) => Record.fromMap(e))
        .toList();
  }

  @override
  Future<void> update(Record record) async {
    (await database).update(
      'records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  @override
  Future<List<Record>> getAllRecords({int categoryId}) {
    if (categoryId == null) {
      return getAll();
    }
    return getAllFromCategory(categoryId: categoryId);
  }

  @override
  Future<Record> getById(int id) async {
    List<Map> recordInList = await (await database).query(
      'records',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return recordInList.isNotEmpty ? Record.fromMap(recordInList.first) : null;
  }

  @override
  Future<Record> getLastFromCategory({int categoryId}) async {
    List<Map> records = await (await database).query(
      'records',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
      orderBy: 'createDateTime DESC',
      limit: 1,
    );
    return records.isNotEmpty ? Record.fromMap(records.first) : null;
  }

  @override
  Future<int> getRecordsCount({int categoryId, bool onlyFavorites}) async {
    final queryStringBuffer = StringBuffer('SELECT COUNT(*) FROM records ');
    if (categoryId != null) {
      queryStringBuffer.write('WHERE categoryId = $categoryId ');
      if (onlyFavorites ?? false) {
        queryStringBuffer.write('AND isFavorite = 1 ');
      }
    } else if (onlyFavorites ?? false) {
      queryStringBuffer.write('WHERE isFavorite = 1 ');
    }

    final value = Sqflite.firstIntValue(
      await (await database).rawQuery(
        queryStringBuffer.toString(),
      ),
    );
    return value;
  }
}
