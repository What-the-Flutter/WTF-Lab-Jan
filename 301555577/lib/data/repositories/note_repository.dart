import '../models/category_model.dart';
import '../models/note_model.dart';

import 'db/db_provider.dart';
import 'mappers/note_mapper.dart';

class NoteRepository {
  final DbProvider dbProvider;

  NoteRepository(this.dbProvider);

  Future<List<Note>> fetchNotes(Category category) async {
    final dbNotes = await dbProvider.notesFor(category);
    return dbNotes.map(NoteMapper.fromDb).toList();
  }

  Future<int> addNote(int categoryId, Note note) async {
    return dbProvider.insertNote(categoryId, NoteMapper.toDb(note));
  }

  Future<bool> deleteNotes(List<Note> notes) async {
    return dbProvider.deleteNotes(notes.map(NoteMapper.toDb).toList());
  }

  Future<int> updateNote(Note note) async {
    return dbProvider.updateNote(NoteMapper.toDb(note));
  }

  Future<bool> updateNoteCategory(Category category, List<Note> notes) async {
    return dbProvider.updateNoteCategories(
        category.id!, notes.map(NoteMapper.toDb).toList());
  }
}
