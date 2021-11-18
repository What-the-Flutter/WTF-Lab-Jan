import 'dart:async';
import 'package:chat_journal/models/chat_model.dart';
import 'package:chat_journal/models/chaticon_model.dart';
import 'package:chat_journal/models/message_model.dart';
import 'package:chat_journal/models/sectionicon_model.dart';
import 'package:firebase_database/firebase_database.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.reference();

  void initDB(DatabaseReference databaseRef) {
    initTableChatIcons(databaseRef);
    initTableSectionIcons(databaseRef);
  }

  DatabaseReference get databaseRef => _databaseRef;

  void initTableChatIcons(DatabaseReference dbRef) async {
    for (var ico in chatIconsList) {
      await dbRef.child('chatIcons').push().set(ico.toJson());
    }
  }

  void initTableSectionIcons(DatabaseReference dbRef) async {
    for (var ico in sectionIconsList) {
      await dbRef.child('sectionIcons').push().set(ico.toJson());
    }
  }

  Future<List<String>> fetchChatIconsList() async {
    final dbNotesList = await _databaseRef.child('chatIcons').once();
    final Map<dynamic, dynamic> values = dbNotesList.value;
    final chatIconsList = <String>[];
    values.forEach((key, value) {
      final chatIcon = ChatIcon.fromMap(key, value);
      chatIconsList.add(chatIcon.iconTitle);
    });
    return chatIconsList;
  }

  Future<List<SectionIcon>> fetchSectionIconsList() async {
    final dbNotesList = await _databaseRef.child('sectionIcons').once();
    final Map<dynamic, dynamic> values = dbNotesList.value;
    final sectionIconsList = <SectionIcon>[];
    values.forEach((key, value) {
      sectionIconsList.add(SectionIcon.fromMap(key, value));
    });
    return sectionIconsList;
  }

  Future<List<Message>> fetchFavouriteMessages(String chatId) async {
    final dbNotesList =
        await _databaseRef.child('messages').child(chatId).once();
    final Map<dynamic, dynamic> values = dbNotesList.value;
    final favouritesList = <Message>[];
    values.forEach((key, value) async {
      final favourite = Message.fromMap(key, value);
      if (favourite.isFavourite == true) {
        favouritesList.insert(0, favourite);
      }
    });

    return favouritesList;
  }

  Future<void> insertChat(Chat chat) async {
    await _databaseRef.child('chats').push().set(chat.toJson());
  }

  Future<void> deleteChat(Chat chat) async {
    await _databaseRef.child('chats').child(chat.id!).remove();
  }

  Future<void> updateChat(Chat chat) async {
    await _databaseRef
        .reference()
        .child('chats')
        .child(chat.id!)
        .set(chat.toJson());
  }

  Future<List<Chat>> fetchChatsList() async {
    final dbNotesList = await _databaseRef.child('chats').once();
    final Map<dynamic, dynamic> values = dbNotesList.value;
    final chatsList = <Chat>[];
    values.forEach((key, value) async {
      final chat = Chat.fromMap(key, value);
      if (chat.isPinned == true) {
        chatsList.insert(0, chat);
      } else {
        chatsList.add(chat);
      }
    });
    return chatsList;
  }

  Future<void> deleteAllMessages(String chatId) async {
    await _databaseRef.child('messages').child(chatId).remove();
  }

  Future<Chat> fetchChatById(String id) async {
    final dbNotesList = await _databaseRef.child('chats').child(id).once();
    final Map<dynamic, dynamic> values = dbNotesList.value;
    final chat = Chat.fromMap(id, values);
    return chat;
  }

  Future<List<Message>> searchMessages(String chatId, String text) async {
    if (text.isNotEmpty) {
      final dbNotesList =
          await _databaseRef.child('messages').child(chatId).once();
      final Map<dynamic, dynamic> values = dbNotesList.value;
      final messagesList = <Message>[];
      values.forEach((key, value) async {
        final message = Message.fromMap(key, value);
        if (message.message.contains(text)) {
          messagesList.insert(0, message);
        }
      });
      return messagesList;
    } else {
      return [];
    }
  }

  Future<void> insertMessage(Message message, String chatId) async {
    await _databaseRef
        .child('messages')
        .child(chatId)
        .push()
        .set(message.toJson());
  }

  Future<void> deleteMessage(Message message, String chatId) async {
    await _databaseRef
        .child('messages')
        .child(chatId)
        .child(message.id!)
        .remove();
  }

  Future<void> updateMessage(Message message, String chatId) async {
    await _databaseRef
        .child('messages')
        .child(chatId)
        .child(message.id!)
        .set(message.toJson());
  }

  Future<List<Message>> fetchMessagesList(String chatId) async {
    final dbNotesList =
        await _databaseRef.child('messages').child(chatId).once();
    final messagesList = <Message>[];
    if (dbNotesList.exists) {
      final Map<dynamic, dynamic> values = dbNotesList.value;
      values.forEach((key, value) async {
        final message = Message.fromMap(key, value);
        messagesList.insert(0, message);
      });
    }
    return messagesList;
  }
}
