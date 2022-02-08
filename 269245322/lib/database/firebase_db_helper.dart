import 'package:firebase_database/firebase_database.dart';

import '../models/note_model.dart';
import '../models/page_model.dart';
import '../services/entity_repository.dart';

class FireBasePageHelper extends EntityRepository<PageModel> {
  final referenceDatabase = FirebaseDatabase.instance;

  void initFireBase() async {
    final ref = referenceDatabase.ref();
    await ref.child('pages').update({'num_of_pages': 0}).asStream();
  }

  Future<int> getNumOfPages() async {
    final ref = referenceDatabase.ref();
    var snapShot = await ref.child('pages').child('num_of_pages').get();
    final value = snapShot.value as int;
    final numOfPages = value;
    return numOfPages;
  }

  @override
  Future<List<PageModel>> getEntityList(
    String? dbPageTitle,
    String? dbNoteTitle,
  ) async {
    var fireBaseNoteHelper = FireBaseNoteHelper();
    final numOfPages = await getNumOfPages();
    final ref = referenceDatabase.ref();
    final pagesList = <PageModel>[];
    for (var i = 0; i < numOfPages; i++) {
      var dbPage = await ref.child('pages').child('page $i').get();
      final dbValue = dbPage.value as Map<dynamic, dynamic>;
      var page = PageModel.fromMapFireBase(dbValue, 'page $i');
      page = page.copyWith(
          notesList: await fireBaseNoteHelper.getEntityList(
              page.fireBaseTitle!, page.title));
      pagesList.add(page);
      print(page.fireBaseTitle);
    }
    return pagesList;
  }

  @override
  void insert(
      PageModel entity, String? pageTitle, String? firebasePageTitle) async {
    final ref = referenceDatabase.ref();

    try {
      await ref.child('pages').child('page ${await getNumOfPages()}').set({
        'title': entity.title,
        'icon': entity.icon,
        'num_of_notes': entity.numOfNotes,
        'cretion_date': entity.cretionDate,
        'last_modifed_date': entity.lastModifedDate,
      }).asStream();
      // updating num of pages on the server after inserting a new one
      await ref
          .child('pages')
          .update({'num_of_pages': await getNumOfPages() + 1}).asStream();
    } on Exception {
      initFireBase();
    }
  }

  @override
  void update(PageModel entity, String? pageTitle, String? firebasePageTitle) {
    final ref = referenceDatabase.ref();
    ref.child('pages').child(entity.fireBaseTitle!).update({
      'title': entity.title,
      'icon': entity.icon,
      'num_of_notes': entity.numOfNotes,
      'cretion_date': entity.cretionDate,
      'last_modifed_date': entity.lastModifedDate,
    }).asStream();
  }

  @override
  void delete(
    PageModel entity,
    String? pageTitle,
    String? firebasePageTitle,
  ) async {
    final ref = referenceDatabase.ref();
    final firebasePageTitle = entity.fireBaseTitle;
    ref.child('pages').child(firebasePageTitle!).remove().asStream();
    // updating num of pages on the server after deleting existing
    ref
        .child('pages')
        .update({'num_of_pages': await getNumOfPages() - 1}).asStream();
  }
}

class FireBaseNoteHelper extends EntityRepository<NoteModel> {
  final referenceDatabase = FirebaseDatabase.instance;

  Future<int> getNumOfNotes(String dbPageTitle) async {
    final ref = referenceDatabase.ref();
    var snapShot =
        await ref.child('pages').child(dbPageTitle).child('num_of_notes').get();
    final value = snapShot.value as int;
    final numOfPages = value;
    return numOfPages;
  }

  @override
  Future<List<NoteModel>> getEntityList(
    String? dbPageTitle,
    String? dbNoteTitle,
  ) async {
    final ref = referenceDatabase.ref();
    final notesList = <NoteModel>[];

    for (var i = 0; i < await getNumOfNotes(dbPageTitle!); i++) {
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

  @override
  void insert(NoteModel entity, String? pageTitle, String? firebasePageTitle) {
    final ref = referenceDatabase.ref();
    ref.child('pages').child(firebasePageTitle!).child(entity.heading).set({
      'heading': entity.heading,
      'title': pageTitle,
      'data': entity.data,
      'icon': entity.icon,
      'is_favorite': entity.isFavorite,
      'is_searched': entity.isSearched,
      'is_checked': entity.isChecked,
      'download_URL': entity.downloadURL,
    }).asStream();
  }

  @override
  void update(NoteModel entity, String? pageTitle, String? firebasePageTitle) {
    final ref = referenceDatabase.ref();
    ref.child('pages').child(firebasePageTitle!).child(entity.heading).update({
      'heading': entity.heading,
      'title': pageTitle,
      'data': entity.data,
      'icon': entity.icon,
      'is_favorite': entity.isFavorite,
      'is_searched': entity.isSearched,
      'is_checked': entity.isChecked,
      'download_URL': entity.downloadURL,
    }).asStream();
  }

  @override
  void delete(NoteModel entity, String? pageTitle, String? firebasePageTitle) {
    final ref = referenceDatabase.ref();
    final heading = entity.heading;
    ref
        .child('pages')
        .child(firebasePageTitle!)
        .child(heading)
        .remove()
        .asStream();
  }
}
