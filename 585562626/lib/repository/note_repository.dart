import '../models/category.dart';

import '../models/note.dart';

class NoteRepository {
  final Map<int, List<BaseNote>> notes = {};

  Future<List<BaseNote>> fetchNotes(NoteCategory category) async {
    if (notes[category.id] == null) {
      notes[category.id] = [];
    }
    return notes[category.id] ?? [];
  }

  Future<List<BaseNote>> fetchStarredNotes(NoteCategory category) async {
    if (notes[category.id] == null) {
      notes[category.id] = [];
    }
    return notes[category.id]?.where((element) => element.hasStar).toList() ?? [];
  }

  Future addNote(int categoryId, BaseNote note) async {
    notes[categoryId]?.add(note);
  }

  Future switchStar(List<BaseNote> notes) async {
    for (final list in this.notes.values) {
      for (final element in list) {
        if (notes.contains(element)) {
          element.hasStar = !element.hasStar;
        }
      }
    }
  }

  Future deleteNotes(List<BaseNote> notes) async {
    for (final list in this.notes.values) {
      list.removeWhere(notes.contains);
    }
  }

  Future updateNote(BaseNote note) async {}
}
