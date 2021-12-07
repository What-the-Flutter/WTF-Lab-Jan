import '../data_provider/journal_database.dart';
import '../models/event.dart';

class EventRepository {
  final JournalDatabase _db;

  EventRepository(this._db);

  void insertEvent(Event event) {
    _db.insertEvent(event);
  }

  void deleteEvent(Event event) {
    _db.deleteEvent(event);
  }

  void updateEvent(Event event) {
    _db.updateEvent(event);
  }

  Future<List<Event>> fetchEventList(String pageId) async {
    return await _db.fetchEventList(pageId);
  }

  Future<List<Event>> fetchSelectedEventList() async {
    return await _db.fetchSelectedEventList();
  }

  Future<List<Event>> fetchMarkedAllEventList(String pageId) async {
    return await _db.fetchAllMarkEventList(pageId);
  }

  Future<List<Event>> fetchSearchedEventList(String pageId, String text) async {
    return await _db.fetchSearchedEventList(pageId, text);
  }
}
