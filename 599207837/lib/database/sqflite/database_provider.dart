import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../entity/entities.dart';

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
        await db.execute(
          'CREATE TABLE Message ('
          'id INTEGER PRIMARY KEY,'
          'type_id INTEGER,'
          'topic_id INTEGER,'
          'description TEXT,'
          'time_created TEXT,'
          'favourite BIN,'
          'time_completed TEXT,'
          'scheduled_time TEXT,'
          'is_visited BIN,'
          'is_missed BIN'
          ')',
        );
      },
    );
  }

  Future<int> newTopic(Topic newTopic) async {
    final db = await database;
    final res = await db.insert('Topic', newTopic.toJson());
    return res;
  }

  Future<int> updateTopic(Topic topic) async {
    final db = await database;
    final res = await db.update('Topic', topic.toJson(), where: 'id = ?', whereArgs: [topic.id]);
    return res;
  }

  void deleteTopic(Topic topic) async {
    final db = await database;
    db.delete('Topic', where: 'id = ${topic.id}');
    deleteAllMessages(topic);
  }

  Future<List<Topic>> loadTopics() async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM Topic'));
    if (count == 0) {
      return [];
    } else {
      final res = await db.query('Topic');
      final list = res.isNotEmpty ? res.map((c) => Topic.fromJson(c)).toList() : [];
      return list as List<Topic>;
    }
  }

  Future<int> newMessage(Message message) async {
    final db = await database;
    final res = await db.insert('Message', message.toJson());
    return res;
  }

  Future<int> updateMessage(Message message) async {
    final db = await database;
    final res = await db.update('Message', message.toJson(), where: 'id = ${message.uuid}');
    return res;
  }

  Future<Message> loadLastMessage(Topic topic) async {
    final db = await database;
    final res = await db.query(
      'Message',
      where: 'topic_id = ${topic.id}',
      orderBy: 'time_created DESC',
      limit: 1,
    );
    final list = res.map((c) => Message.fromJson(c, topic)).toList();
    return list[0];
  }

  void deleteMessage(Message message) async {
    final db = await database;
    db.delete('Message', where: 'id = ${message.uuid}');
  }

  void deleteAllMessages(Topic topic) async {
    final db = await database;
    db.rawDelete('Delete from Message WHERE topic_id = ${topic.id}');
  }

  Future<List<Message>> loadTopicMessages(Topic topic) async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM Message WHERE topic_id = ${topic.id}',
    ));
    if (count == 0) {
      return [];
    } else {
      final res = await db.query(
        'Message',
        where: 'topic_id = ${topic.id}',
        orderBy: 'time_created DESC',
      );
      final list = res.isNotEmpty ? res.map((c) => Message.fromJson(c, topic)).toList() : [];
      return list as List<Message>;
    }
  }

  Future<List<Message>> loadTypeFavourites(int typeID) async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM Message WHERE type_id = $typeID AND favourite = 1',
    ));
    if (count == 0) {
      return [];
    } else {
      final res = await db.query(
        'Message',
        where: 'type_id = $typeID AND favourite = 1',
        orderBy: 'time_created',
      );
      final list = res.isNotEmpty ? res.map((c) => Message.fromJson(c, null)).toList() : [];
      return list as List<Message>;
    }
  }
}
