import 'package:flutter/material.dart';

import '../../model/record.dart';
import '../records_repository.dart';
import 'provider/local_database_provider.dart';

class LocalDatabaseRecordsRepository extends LocalDatabaseProvider
    implements RecordsRepository {
  @override
  Future<Record> delete(int id) async {
    final record = Record.fromMap(
      (await (await database)
              .query('records', where: 'id = ?', whereArgs: [id]))
          .first,
    );
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
  Future<List<Record>> getAllFromCategory({@required int categoryId}) async {
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
}
