import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/entities.dart' as entity;

class DBProvider {
  static final DBProvider db = DBProvider._inner();
  static Database? _database;

  DBProvider._inner();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'CustomDB.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) async {},
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE Topic ('
          'id INTEGER PRIMARY KEY,'
          'name TEXT,'
          'icon_data INTEGER,'
          'elements INTEGER,'
          'pinned INTEGER,'
          'archived INTEGER,'
          'time_created TEXT'
          ')',
        );
      },
    );
  }

  Future<int> newTopic(entity.Topic newTopic) async {
    final db = await database;
    final res = await db.insert('Topic', newTopic.toJson());
    _crateTopicTable(newTopic);
    return res;
  }

  Future<int> updateTopic(entity.Topic topic) async {
    final db = await database;
    final res = await db.update('Topic', topic.toJson(), where: 'id = ?', whereArgs: [topic.id]);
    return res;
  }

  void deleteTopic(entity.Topic topic) async {
    final db = await database;
    db.delete('Topic', where: 'id = ${topic.id}');
    _deleteTopicTable(topic);
  }

  void _crateTopicTable(entity.Topic topic) async {
    final db = await database;
    await db.execute(
      'CREATE TABLE t${topic.id.toString()} ('
      'id INTEGER PRIMARY KEY,'
      'type_id INTEGER,'
      'description TEXT,'
      'time_created TEXT,'
      'favourite BIN,'
      'time_completed TEXT,'
      'scheduled_time TEXT,'
      'is_visited BIN,'
      'is_missed BIN'
      ')',
    );
  }

  void _deleteTopicTable(entity.Topic topic) async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS t${topic.id.toString()}');
  }

  Future<List<entity.Topic>> getAllTopics() async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM Topic'));
    if (count == 0) {
      return [];
    } else {
      final res = await db.query('Topic');
      final list = res.isNotEmpty ? res.map((c) => entity.Topic.fromJson(c)).toList() : [];
      return list as List<entity.Topic>;
    }
  }

  Future<int> newMessage(entity.Message o) async {
    final db = await database;
    final res = await db.insert('t${o.topic.id.toString()}', o.toJson());
    return res;
  }

  Future<int> updateMessage(entity.Message o) async {
    final db = await database;
    final res = await db
        .update('t${o.topic.id.toString()}', o.toJson(), where: 'id = ?', whereArgs: [o.uuid]);
    return res;
  }

  void deleteMessage(entity.Message o) async {
    final db = await database;
    db.delete('t${o.topic.id.toString()}', where: 'id = ${o.uuid}');
  }

  void deleteAllMessages(entity.Topic topic) async {
    final db = await database;
    db.rawDelete('Delete from t${topic.id.toString()}');
  }

  Future<List<entity.Message>> getLastMessages(entity.Topic topic) async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM t${topic.id.toString()}',
    ));
    if (count == 0) {
      return [];
    } else {
      final res = await db.query(
        't${topic.id.toString()}',
        orderBy: 'time_created DESC',
        limit: 25,
      );
      final list = res.isNotEmpty ? res.map((c) => entity.Message.fromJson(c, topic)).toList() : [];
      return list as List<entity.Message>;
    }
  }
}
