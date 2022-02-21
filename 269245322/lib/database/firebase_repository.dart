import 'package:firebase_database/firebase_database.dart';

import '../models/note_model.dart';
import '../models/page_model.dart';
import '../services/entity_repository.dart';

final String firebaseMainTable = 'pages';
final String firebaseNotesTable = 'notes';

class FireBasePageHelper extends IRepository<PageModel> {
  final referenceDatabase = FirebaseDatabase.instance;
  final _pagesRef = FirebaseDatabase.instance.ref().child(firebaseMainTable);

  @override
  Future<List<PageModel>> getEntityList(int? pageId) async {
    final fireBaseNoteHelper = FireBaseNoteHelper();
    final pageList = <PageModel>[];
    final pagesSnap = await _pagesRef.once();
    for (final pageSnap in pagesSnap.snapshot.children) {
      final dbValue = pageSnap.value as Map<dynamic, dynamic>;
      var page = PageModel.fromMapFireBase(dbValue);
      page = page.copyWith(
        notesList: await fireBaseNoteHelper.getEntityList(page.id),
      );
      pageList.add(page);
    }
    return pageList;
  }

  @override
  void insert(PageModel entity, int? pageId) async {
    final ref = referenceDatabase.ref();

    try {
      await ref.child(firebaseMainTable).child('page ${entity.id}').set({
        'id': entity.id,
        'title': entity.title,
        'icon': entity.icon,
        'num_of_notes': entity.numOfNotes,
        'cretion_date': entity.cretionDate,
        'last_modifed_date': entity.lastModifedDate,
      }).asStream();
    } on Exception {
      print(Exception(':c'));
    }
  }

  @override
  void update(PageModel entity, int? pageId) {
    final ref = referenceDatabase.ref();
    ref.child(firebaseMainTable).child('page ${entity.id}').update({
      'id': entity.id,
      'title': entity.title,
      'icon': entity.icon,
      'num_of_notes': entity.numOfNotes,
      'cretion_date': entity.cretionDate,
      'last_modifed_date': entity.lastModifedDate,
    }).asStream();
  }

  @override
  void delete(PageModel entity, int? pageId) async {
    final ref = referenceDatabase.ref();
    ref.child(firebaseMainTable).child('page ${entity.id}').remove().asStream();
  }
}

class FireBaseNoteHelper extends IRepository<NoteModel> {
  final referenceDatabase = FirebaseDatabase.instance;
  final _pagesRef = FirebaseDatabase.instance.ref().child(firebaseMainTable);

  @override
  Future<List<NoteModel>> getEntityList(int? pageId) async {
    final _notesRef = FirebaseDatabase.instance
        .ref()
        .child(firebaseMainTable)
        .child('page $pageId')
        .child(firebaseNotesTable);
    final notesList = <NoteModel>[];
    final notesSnap = await _notesRef.once();
    for (final noteSnap in notesSnap.snapshot.children) {
      final dbValue = noteSnap.value as Map<dynamic, dynamic>;
      final note = NoteModel.fromMapFireBase(dbValue);
      notesList.add(note);
    }
    return notesList;
  }

  Future<List<NoteModel>> getAllNotes() async {
    final allNotesList = <NoteModel>[];
    final pagesSnap = await _pagesRef.once();
    for (final pageSnap in pagesSnap.snapshot.children) {
      final dbValue = pageSnap.value as Map<dynamic, dynamic>;
      var page = PageModel.fromMapFireBase(dbValue);
      for (final note in await getEntityList(page.id)) {
        allNotesList.add(note);
      }
    }
    return allNotesList;
  }

  @override
  void insert(NoteModel entity, int? pageId) {
    final ref = referenceDatabase.ref();
    ref
        .child(firebaseMainTable)
        .child('page $pageId')
        .child(firebaseNotesTable)
        .child('note ${entity.id}')
        .set({
      'id': entity.id,
      'heading': entity.heading,
      'data': entity.data,
      'icon': entity.icon,
      'is_favorite': entity.isFavorite,
      'is_searched': entity.isSearched,
      'is_checked': entity.isChecked,
      'download_URL': entity.downloadURL,
      'tags': entity.tags ?? ' ',
    }).asStream();
  }

  @override
  void update(NoteModel entity, int? pageId) {
    final ref = referenceDatabase.ref();
    ref
        .child(firebaseMainTable)
        .child('page $pageId')
        .child(firebaseNotesTable)
        .child('note ${entity.id}')
        .update({
      'id': entity.id,
      'heading': entity.heading,
      'data': entity.data,
      'icon': entity.icon,
      'is_favorite': entity.isFavorite,
      'is_searched': entity.isSearched,
      'is_checked': entity.isChecked,
      'download_URL': entity.downloadURL,
      'tags': entity.tags ?? ' ',
    }).asStream();
  }

  @override
  void delete(NoteModel entity, int? pageId) {
    final ref = referenceDatabase.ref();
    print('note ${entity.id}');
    ref
        .child(firebaseMainTable)
        .child('page $pageId')
        .child(firebaseNotesTable)
        .child('note ${entity.id}')
        .remove()
        .asStream();
  }
}
