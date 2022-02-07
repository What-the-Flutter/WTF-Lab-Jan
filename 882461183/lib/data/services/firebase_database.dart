import 'package:firebase_database/firebase_database.dart';
import '/models/chat_model.dart';
import '/models/event_model.dart';

class FBDatabase {
  final database = FirebaseDatabase.instance.ref();

  final _chatRef = FirebaseDatabase.instance.ref().child('Chats/');
  final _eventRef = FirebaseDatabase.instance.ref().child('Events/');

  Future<void> insertEvent(Event event) async {
    await _eventRef.child(event.id).set(event.toJson());
  }

  Future<void> insertChat(Chat chat) async {
    await _chatRef.child(chat.id).set(chat.toJson());
  }

  Future<void> updateEvent(Event event) async {
    await _eventRef.child(event.id).update(event.toJson());
  }

  Future<void> updateChat(Chat chat) async {
    await _chatRef.child(chat.id).update(chat.toJson());
  }

  Future<void> deleteEvent(Event event) async {
    await _eventRef.child(event.id).remove();
  }

  Future<void> deleteChat(Chat chat) async {
    await _chatRef.child(chat.id).remove();
  }

  Future<List<Chat>> fetchChatList() async {
    final chatList = <Chat>[];
    final snap = await _chatRef.once();
    for (var elSnap in snap.snapshot.children) {
      final result = Map<String, dynamic>.from(elSnap.value as Map);
      chatList.insert(0, Chat.fromJson(Map<String, dynamic>.from(result)));
    }
    return chatList;
  }

  Future<List<Event>> fetchEventList(String chatId) async {
    final eventList = <Event>[];
    final snap = await _eventRef.once();
    for (var elSnap in snap.snapshot.children) {
      final result = Map<String, dynamic>.from(elSnap.value as Map);
      if (result.containsValue(chatId)) {
        eventList.insert(0, Event.fromJson(Map<String, dynamic>.from(result)));
      }
    }

    return eventList;
  }
}
