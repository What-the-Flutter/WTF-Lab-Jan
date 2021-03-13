import 'package:chat_journal/model/category.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class Repository<T> {
  Future<void> insert(T obj);

  Future<void> update(T obj);

  Future<T> delete(int id);

  Future<List<T>> getAll();
}
