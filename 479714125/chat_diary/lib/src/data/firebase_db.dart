import 'dart:developer';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/event_model.dart';
import '../models/page_model.dart';

class FirebaseDBProvider {
  final FirebaseDatabase _firebaseDatabase;
  late final DatabaseReference _refPages;
  late final DatabaseReference _refMessages;

  FirebaseDBProvider() : _firebaseDatabase = FirebaseDatabase.instance {
    _refPages = _firebaseDatabase.ref().child('pages');
    _refMessages = _firebaseDatabase.ref().child('messages');
  }

  Future<List<PageModel>> retrievePages() async {
    final event = await _refPages.once();
    var pages = <PageModel>[];
    try {
      final value = event.snapshot.value;
      if (value != null) {
        final listOfMaps = (value as List<Object?>)
            .where((element) => element != null)
            .cast<Map<dynamic, dynamic>>();
        pages = listOfMaps.map((e) => PageModel.fromMap(e)).toList();
      }
    } catch (e) {
      log(e.toString());
    }
    return pages;
  }

  Future<void> insertPage(PageModel page) async {
    final pageJson = page.toMap();
    await _refPages.child(page.id.toString()).set(pageJson);
  }

  Future<void> updatePage(PageModel newPage) async {
    final pageJson = newPage.toMap();
    await _refPages.child(newPage.id.toString()).set(pageJson);
  }

  Future<void> removePage(int id) async {
    await _refPages.child(id.toString()).remove();
  }

  Future<void> addEvent(EventModel event) async {
    final eventJson = event.toMap();
    await _refMessages
        .child(event.pageId.toString())
        .child(event.id.toString())
        .set(eventJson);
  }

  Future<List<EventModel>> retrieveEvents(int pageId) async {
    final databaseEvent = await _refMessages.child(pageId.toString()).once();
    final value = databaseEvent.snapshot.value;
    var events = <EventModel>[];
    if (value != null) {
      try {
        final listOfMaps = (value as List<Object?>)
            .where((element) => element != null)
            .cast<Map<dynamic, dynamic>>();
        events = listOfMaps.map((e) => EventModel.fromMap(e)).toList();
      } catch (e) {
        log(e.toString());
      }
    }
    return events;
  }

  Future<void> toggleEventSelection(EventModel event) async {
    final eventJson = event.toMap();
    await _refMessages
        .child(event.pageId.toString())
        .child(event.id.toString())
        .set(eventJson);
  }

  Future<void> updateEvent(EventModel event) async {
    final eventJson = event.toMap();
    await _refMessages
        .child(event.pageId.toString())
        .child(event.id.toString())
        .set(eventJson);
  }

  Future<List<EventModel>> fetchSelectedEvents(int pageId) async {
    final ref = _refMessages.child(pageId.toString());
    final snapshot = await ref.get();
    final data = snapshot.value;
    var events = <EventModel>[];
    if (data != null) {
      try {
        final listOfMaps = (data as List<Object?>)
            .where((element) => element != null)
            .cast<Map<dynamic, dynamic>>();
        events = listOfMaps
            .map((e) => EventModel.fromMap(e))
            .where((element) => element.isSelected)
            .toList();
      } catch (e) {
        log(e.toString());
      }
    }
    return events;
  }

  Future<void> toggleAllSelected(List<EventModel> events) async {
    final map = <String, Map<dynamic, dynamic>>{};
    for (var element in events) {
      map[element.id.toString()] = element.toMap();
    }
    await _refMessages.child(events[0].pageId.toString()).update(map);
  }

  Future<void> deleteSelectedEvents(
      int pageId, List<EventModel> newEvents) async {
    final map = <String, Map<dynamic, dynamic>>{};
    for (var element in newEvents) {
      map[element.id.toString()] = element.toMap();
    }
    await _refMessages.child(pageId.toString()).set(map);
  }

  Future<void> uploadImageToStorage(String fileName, File fileImage) async {
    final storage = FirebaseStorage.instance;
    await storage.ref('images/$fileName').putFile(fileImage);
  }
}
