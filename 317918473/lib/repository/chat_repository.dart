
import '../models/message.dart';
import '../services/databases/db_category.dart';

class ChatRepository {
  final _db = DBProvider.instance;

  Future<List<Messages>> getAll(String categoryId) async =>
      await _db.getAllMessages(categoryId);

  void add(Messages message) => _db.addMessage(message);

  void delete() => _db.deleteMessage();

  void update(Messages messages) => _db.updateMessage(messages);

  void addOrRemoveToFavorite() => _db.addOrRemoveMessageToFavorite();

  void sendImage(Messages message) => _db.addMessage(message);

  void unselectAll() => _db.unselectMessages();

  void addMessages(String chatId) {
    _db.messageToAnotherCategory(chatId);
  }
}
