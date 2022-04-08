import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '/data/services/firebase_api.dart';
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

  Future<List<Event>> fetchAllEventList() async {
    return await _database.fetchAllEventLists();
  }

  Future<UploadTask?> uploadFile(String destination, File file) async {
    await FirebaseApi.uploadFile(destination, file);
  }

  UploadTask? deleteFile(String destination) {
    FirebaseApi.deleteFile(destination);
  }

  Future<String> getFile(String destination) {
    return FirebaseApi.getFile(destination);
  }
}
