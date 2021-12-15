import '../data_provider/firebase_database_provider.dart';
import '../model/event.dart';

class EventRepository {
  final FirebaseDatabaseProvider _db;

  EventRepository(this._db);

  void addImageEvent(String eventId, String imagePath) {
    _db.addImageEvent(eventId, imagePath);
  }

  void insertEvent(Event event) {
    _db.insertEvent(event);
  }

  void deleteEvent(Event event) {
    _db.deleteEvent(event);
  }

  void updateEvent(Event event) {
    _db.updateEvent(event);
  }

  Future<List<Event>> fetchEventList() async {
    return await _db.fetchEventList();
  }
}
