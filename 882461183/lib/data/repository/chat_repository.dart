import '/data/services/firebase_database.dart';
import '/models/chat_model.dart';

class ChatRepository {
  final FBDatabase _database = FBDatabase();

  void insertChat(Chat chat) {
    _database.insertChat(chat);
  }

  void deleteChat(Chat chat) {
    _database.deleteChat(chat);
  }

  void updateChat(Chat chat) {
    _database.updateChat(chat);
  }

  Future<List<Chat>> fetchChatList() {
    return _database.fetchChatList();
  }
}
