import '../database.dart';
import '../models/events_model.dart';

class MessagesRepository {
  final DBProvider db;

  MessagesRepository(this.db);

  void insertMessage(EventMessage message) {
    db.insertMessage(message);
  }

  void updateMessage(EventMessage message) {
    db.updateMessage(message);
  }

  void deleteMessage(String messageId) {
    db.deleteMessage(messageId);
  }

  Future<List<EventMessage>> messagesList(String eventPageId) async {
    return await db.messagesList(eventPageId);
  }

  Future<List> allMessagesList() async {
    return await db.allMessagesList();
  }

  Future<List<EventMessage>> markedMessagesList(String eventPageId) async {
    return await db.markedMessagesList(eventPageId);
  }

  Future<List<EventMessage>> allMarkedMessagesList() async {
    return await db.allMarkedMessagesList();
  }

  Future<List<EventMessage>> searchMessagesList(
    String eventPageId,
    String searchText,
  ) async {
    return await db.searchMessagesList(eventPageId, searchText);
  }

  Future<List<EventMessage>> allSearchMessagesList(
    String searchText,
  ) async {
    return await db.allSearchMessagesList(searchText);
  }
}
