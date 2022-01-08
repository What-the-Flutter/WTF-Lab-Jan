import '../data_provider/firebase_database_provider.dart';
import '../data_provider/firebase_firestore_provider.dart';
import '../model/event.dart';

class EventRepository {
  final FirebaseDatabaseProvider _realtimeDb;
  final FirebaseFirestoreProvider _firebaseDb;

  EventRepository(this._realtimeDb, this._firebaseDb);

  void addImageEvent(String eventId, String imagePath) {
    _firebaseDb.addImageEvent(eventId, imagePath);
  }

  void insertEvent(Event event) {
    _realtimeDb.insertEvent(event);
  }

  void deleteEvent(Event event) {
    _realtimeDb.deleteEvent(event);
  }

  void updateEvent(Event event) {
    _realtimeDb.updateEvent(event);
  }

  Future<List<Event>> fetchEventList() async {
    return await _realtimeDb.fetchEventList();
  }
}
