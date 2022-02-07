import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/note_model.dart';
import '../models/page_model.dart';

class FireBaseHelper {
  final referenceDatabase = FirebaseDatabase.instance;

  void initFireBase() async {
    final ref = referenceDatabase.ref();
    await ref.child('pages').update({'num_of_pages': 0}).asStream();
  }

  Future<List<PageModel>> dbPagesList() async {
    final numOfPages = await getNumOfPages();
    final ref = referenceDatabase.ref();
    final pagesList = <PageModel>[];
    for (var i = 0; i < numOfPages; i++) {
      var dbPage = await ref.child('pages').child('page $i').get();
      final dbValue = dbPage.value as Map<dynamic, dynamic>;
      var page = PageModel.fromMapFireBase(dbValue, 'page $i');
      page = page.copyWith(
          notesList: await dbNotesList(page.dbTitle!, page.title));
      pagesList.add(page);
      print(page.dbTitle);
    }
    return pagesList;
  }

  Future<List<NoteModel>> dbNotesList(
      String dbPageTitle, String dbNoteTitle) async {
    final ref = referenceDatabase.ref();
    final notesList = <NoteModel>[];

    for (var i = 0; i < await getNumOfNotes(dbPageTitle); i++) {
      var dbNote = await ref
          .child('pages')
          .child(dbPageTitle)
          .child('$dbNoteTitle $i')
          .get();
      final dbValue = dbNote.value as Map<dynamic, dynamic>;
      var note = NoteModel.fromMapFireBase(dbValue);
      notesList.add(note);
    }
    return notesList;
  }

  Future<int> getNumOfPages() async {
    final ref = referenceDatabase.ref();
    var snapShot = await ref.child('pages').child('num_of_pages').get();
    final value = snapShot.value as int;
    final numOfPages = value;
    return numOfPages;
  }

  Future<int> getNumOfNotes(String dbPageTitle) async {
    final ref = referenceDatabase.ref();
    var snapShot =
        await ref.child('pages').child(dbPageTitle).child('num_of_notes').get();
    final value = snapShot.value as int;
    final numOfPages = value;
    return numOfPages;
  }

  void insertPage(PageModel page) async {
    final ref = referenceDatabase.ref();

    try {
      await ref.child('pages').child('page ${await getNumOfPages()}').set({
        'title': page.title,
        'icon': page.icon,
        'num_of_notes': page.numOfNotes,
        'cretion_date': page.cretionDate,
        'last_modifed_date': page.lastModifedDate,
      }).asStream();
      // updating num of pages on the server after inserting a new one
      await ref
          .child('pages')
          .update({'num_of_pages': await getNumOfPages() + 1}).asStream();
    } on Exception {
      initFireBase();
    }
  }

  void editPage(PageModel page) {
    final ref = referenceDatabase.ref();
    ref.child('pages').child(page.dbTitle!).update({
      'title': page.title,
      'icon': page.icon,
      'num_of_notes': page.numOfNotes,
      'cretion_date': page.cretionDate,
      'last_modifed_date': page.lastModifedDate,
    }).asStream();
  }

  void deletePage(String dbPageTitle) async {
    final ref = referenceDatabase.ref();
    ref.child('pages').child(dbPageTitle).remove().asStream();
    // updating num of pages on the server after deleting existing
    ref
        .child('pages')
        .update({'num_of_pages': await getNumOfPages() - 1}).asStream();
  }

  void insertNote(NoteModel note, String pageTitle, String dbPageTitle) {
    final ref = referenceDatabase.ref();
    ref.child('pages').child(dbPageTitle).child(note.heading).set({
      'heading': note.heading,
      'title': pageTitle,
      'data': note.data,
      'icon': note.icon,
      'is_favorite': note.isFavorite,
      'is_searched': note.isSearched,
      'is_checked': note.isChecked,
    }).asStream();
  }

  void editNote(NoteModel note, String pageTitle, String dbPageTitle) {
    final ref = referenceDatabase.ref();
    ref.child('pages').child(dbPageTitle).child(note.heading).update({
      'heading': note.heading,
      'title': pageTitle,
      'data': note.data,
      'icon': note.icon,
      'is_favorite': note.isFavorite,
      'is_searched': note.isSearched,
      'is_checked': note.isChecked,
    }).asStream();
  }

  void deleteNote(String dbPageTitle, String heading) {
    final ref = referenceDatabase.ref();
    ref.child('pages').child(dbPageTitle).child(heading).remove().asStream();
  }

  void uploadFile(String destination, File file) async {
    final ref = FirebaseStorage.instance.ref(destination);
    ref.putFile(file);
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in anon
  Future signInAnon() async {
    try {
      final result = await _auth.signInAnonymously();
      final user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
