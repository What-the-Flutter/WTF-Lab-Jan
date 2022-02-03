import '/data/services/firebase_database.dart';
import '/models/event_model.dart';

class EventRepository {
  final FBDatabase _database = FBDatabase();

  void insertEvent(Event event) {
    _database.insertEvent(event);
  }

  void deleteEvent(Event event) {
    _database.deleteEvent(event);
  }

  void updateEvent(Event event) {
    _database.updateEvent(event);
  }

  Future<List<Event>> fetchEventList(String chatId) async {
    return await _database.fetchEventList(chatId);
  }
}
