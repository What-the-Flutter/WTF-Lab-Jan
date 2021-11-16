import 'dart:async';
import 'package:chat_journal/models/chat_model.dart';
import 'package:chat_journal/models/chaticon_model.dart';
import 'package:chat_journal/models/message_model.dart';
import 'package:chat_journal/models/sectionicon_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    final path = join(await getDatabasesPath(), "journal.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table chatIcons(
      id integer primary key autoincrement,
      iconTitle text not null) 
       ''');
      await db.execute('''
      create table sectionIcons(
      id integer primary key autoincrement,
      iconTitle text not null,
      title text not null)
       ''');
      await db.execute('''
      create table chats(
      id integer primary key autoincrement,
      chatIconId integer not null,
      title text not null,
      isPinned integer not null,
      time text not null,
      FOREIGN KEY (chatIconId)
       REFERENCES chatIcons (id))
       ''');
      await db.execute('''
      create table messages(
      id integer primary key autoincrement,
      chatId integer not null,
      message text not null,
      isFavourite integer not null,
      time text not null,
      sectionIconId integer null,
      FOREIGN KEY (sectionIconId)
       REFERENCES sectionIcons (id))
       ''');

      await initTableSectionIcons(db);
      await initTableChatIcons(db);
    });
  }

  Future<void> initTableChatIcons(Database db) async {
    for (var ico in chatIconsList) {
      await db.insert(
        'chatIcons',
        ico.toMap(),
      );
    }
  }

  Future<void> initTableSectionIcons(Database db) async {
    for (var ico in sectionIconsList) {
      await db.insert(
        'sectionIcons',
        ico.toMap(),
      );
    }
  }

  Future<List<ChatIcon>> fetchChatIconsList() async {
    final db = await database;
    final dbNotesList = await db.query('chatIcons');
    final chatIconsList = <ChatIcon>[];
    for (var item in dbNotesList) {
      final chatIcon = ChatIcon.fromMap(item);
      chatIconsList.add(chatIcon);
    }
    return chatIconsList;
  }

  Future<List<SectionIcon>> fetchSectionIconsList() async {
    final db = await database;
    final dbNotesList = await db.query('sectionIcons');
    final sectionIconsList = <SectionIcon>[];
    for (var item in dbNotesList) {
      final sectionIcon = SectionIcon.fromMap(item);
      sectionIconsList.add(sectionIcon);
    }
    return sectionIconsList;
  }

  Future<List<Message>> fetchFavouriteMessages() async {
    final db = await database;
    final dbNotesList = await db.query(
      'messages',
      where: 'isFavourite = ?',
      whereArgs: [1],
    );
    final favouritesList = <Message>[];
    for (var item in dbNotesList) {
      final favourite = Message.fromMap(item);
      if (favourite.sectionIconId != null) {
        favourite.sectionIcon =
            await fetchSectionIconById(favourite.sectionIconId!);
      }
      favouritesList.insert(0, favourite);
    }
    return favouritesList;
  }

  Future<void> insertChat(Chat chat) async {
    final db = await database;
    await db.insert('chats', chat.toMap());
  }

  Future<void> deleteChat(Chat chat) async {
    final db = await database;
    await db.delete(
      'chats',
      where: 'id = ?',
      whereArgs: [chat.id],
    );
  }

  Future<void> updateChat(Chat chat) async {
    final db = await database;
    await db.update(
      'chats',
      chat.toMap(),
      where: 'id = ?',
      whereArgs: [chat.id],
    );
  }

  Future<List<Chat>> fetchChatsList() async {
    final db = await database;
    final dbNotesList =
        await db.rawQuery('select * from chats order by isPinned desc');
    final chatsList = <Chat>[];
    for (var item in dbNotesList) {
      final chat = Chat.fromMap(item);
      chat.chatIcon = await fetchChatIconById(chat.chatIconId);
      chat.messageBase = await fetchMessagesListById(chat.id);
      chatsList.add(chat);
    }
    return chatsList;
  }

  Future<ChatIcon> fetchChatIconById(int id) async {
    final db = await database;
    final dbNotesList = await db.query(
      'chatIcons',
      where: 'id = ?',
      whereArgs: [id],
    );
    final chatIconsList = <ChatIcon>[];
    for (var item in dbNotesList) {
      final chatIcon = ChatIcon.fromMap(item);
      chatIconsList.insert(0, chatIcon);
    }

    return chatIconsList.first;
  }

  Future<Chat> fetchChatById(int id) async {
    final db = await database;
    final dbNotesList = await db.query(
      'chats',
      where: 'id = ?',
      whereArgs: [id],
    );
    final chatsList = <Chat>[];
    for (var item in dbNotesList) {
      final chat = Chat.fromMap(item);
      chat.chatIcon = await fetchChatIconById(chat.chatIconId);
      chat.messageBase = await fetchMessagesListById(chat.id);
      chatsList.insert(0, chat);
    }

    return chatsList.first;
  }

  Future<List<Message>> searchMessages(int chatId, String text) async {
    if (text.isNotEmpty) {
      final db = await database;
      final dbNotesList = await db.rawQuery(
          'select * from messages where chatId = $chatId and message like "%$text%"');
      final messagesList = <Message>[];
      for (var item in dbNotesList) {
        final message = Message.fromMap(item);
        if (message.sectionIconId != null) {
          message.sectionIcon =
              await fetchSectionIconById(message.sectionIconId!);
        }
        messagesList.insert(0, message);
      }

      return messagesList;
    } else {
      return [];
    }
  }

  Future<SectionIcon> fetchSectionIconById(int id) async {
    final db = await database;
    final dbNotesList = await db.query(
      'sectionIcons',
      where: 'id = ?',
      whereArgs: [id],
    );
    final sectionIconsList = <SectionIcon>[];
    for (var item in dbNotesList) {
      final sectionIcon = SectionIcon.fromMap(item);
      sectionIconsList.insert(0, sectionIcon);
    }

    return sectionIconsList.first;
  }

  Future<void> insertMessage(Message message) async {
    final db = await database;
    await db.insert('messages', message.toMap());
  }

  Future<void> deleteMessage(Message message) async {
    final db = await database;
    await db.delete(
      'messages',
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  Future<void> updateMessage(Message message) async {
    final db = await database;
    await db.update(
      'messages',
      message.toMap(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  Future<List<Message>> fetchMessagesListById(int id) async {
    final db = await database;
    final dbNotesList = await db.query(
      'messages',
      where: 'chatId = ?',
      whereArgs: [id],
    );
    final messagesList = <Message>[];
    for (var item in dbNotesList) {
      final message = Message.fromMap(item);
      if (message.sectionIconId != null) {
        message.sectionIcon =
            await fetchSectionIconById(message.sectionIconId!);
      }
      messagesList.insert(0, message);
    }
    return messagesList;
  }
}
