import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'models/chat_model.dart';
import 'models/event_model.dart';

const String tableChats = 'table_chats';
const String tableEvents = 'table_events';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper db = DatabaseHelper._();
  static Database? _database;

  Future<Database?> get database async => _database ??= await _initDB();

  Future<Database> _initDB() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'chat_journal.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableChats(
            id TEXT PRIMATY KEY,
            name TEXT NOT NULL,
            subname TEXT NOT NULL,
            creation_date TEXT NOT NULL,
            icon TEXT NOT NULL,
            is_pinned INTEGER NOT NULL
            )
            ''');
        await db.execute('''
          CREATE TABLE $tableEvents(
            id TEXT PRIMARY KEY,
            chat_id TEXT NOT NULL,
            date TEXT NOT NULL,
            text TEXT NOT NULL,
            image_path TEXT NOT NULL,
            category_icon TEXT,
            category_name TEXT,
            is_selected INTEGER NOT NULL,
            is_favorite INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertChat(Chat chat) async {
    final db = await database;
    return db!.insert(
      tableChats,
      chat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteChat(Chat chat) async {
    final db = await database;
    return db!.delete(
      tableChats,
      where: 'id = ?',
      whereArgs: [chat.id],
    );
  }

  Future<int> updateChat(Chat chat) async {
    final db = await database;
    return await db!.update(
      tableChats,
      chat.toMap(),
      where: 'id = ?',
      whereArgs: [chat.id],
    );
  }

  Future<List<Chat>> fetchChatList() async {
    final db = await database;
    final dbChatList = await db!.query(tableChats);
    final chatList = <Chat>[];
    for (var element in dbChatList) {
      final chat = Chat.fromMap(element);
      chatList.insert(0, chat);
    }
    return chatList;
  }

  Future<int> insertEvent(Event event) async {
    final db = await database;
    return db!.insert(
      tableEvents,
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteEvent(Event event) async {
    final db = await database;
    return db!.delete(
      tableEvents,
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> updateEvent(Event event) async {
    final db = await database;
    return await db!.update(
      tableEvents,
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<List<Event>> fetchEventList(String chatId) async {
    final db = await database;
    db!.execute('VACUUM;');
    final dbEventList = await db.query('$tableEvents where chat_id = $chatId');
    final eventList = <Event>[];
    for (var element in dbEventList) {
      final event = Event.fromMap(element);
      eventList.insert(0, event);
    }
    return eventList;
  }

  Future<List<Event>> fetchFavoritedEvents(String chatId) async {
    final db = await database;
    db!.execute('VACUUM;');
    final dbEventList = await db
        .query('$tableEvents where chat_id = $chatId and is_favorite = true');
    final eventList = <Event>[];
    for (var element in dbEventList) {
      final event = Event.fromMap(element);
      eventList.insert(0, event);
    }
    return eventList;
  }

  Future<List<Event>> fetchSearchedEvents(
    String chatId,
    String searchText,
  ) async {
    final db = await database;
    db!.execute('VACUUM;');
    var dbEventList = await db.query(
        '$tableEvents where chat_id = $chatId and text like "%$searchText%"');
    final eventList = <Event>[];
    for (var element in dbEventList) {
      final event = Event.fromMap(element);
      eventList.insert(0, event);
    }
    return eventList;
  }
}
