import 'package:firebase_storage/firebase_storage.dart';

import '/data/services/firebase_api.dart';
import '/data/services/firebase_database.dart';
import '/models/event_model.dart';

class TimelineRepository {
  final FBDatabase _database = FBDatabase();

  void deleteEvent(Event event) {
    _database.deleteEvent(event);
  }

  void updateEvent(Event event) {
    _database.updateEvent(event);
  }

  UploadTask? deleteFile(String destination) {
    FirebaseApi.deleteFile(destination);
  }

  Future<List<Event>> fetchAllEventLists() async {
    return await _database.fetchAllEventLists();
  }
}
