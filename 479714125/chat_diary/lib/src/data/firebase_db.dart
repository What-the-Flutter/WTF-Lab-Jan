import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

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
    print(event.snapshot.value);
    var pages = <PageModel>[];
    try {
      final listOfMaps =
          (event.snapshot.value as List<Object?>).cast<Map<dynamic, dynamic>>();
      pages = listOfMaps.map((e) => PageModel.fromMap(e)).toList();
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
}
