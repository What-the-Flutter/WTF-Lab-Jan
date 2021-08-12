import '../models/category.dart';
import '../models/note.dart';
import 'database/database_provider.dart';
import 'mappers/note_mapper.dart';

class NoteRepository {
  final DbProvider dbProvider;

  NoteRepository(this.dbProvider);

  Future<List<Note>> fetchNotes(Category category) async {
    final dbNotes = await dbProvider.notesFor(category);
    return dbNotes.map(NoteMapper.fromDb).toList();
  }

  Future<List<Note>> fetchStarredNotes(Category category) async {
    final dbNotes = await dbProvider.starredNotes(category);
    return dbNotes.map(NoteMapper.fromDb).toList();
  }

  Future<void> addNote(int categoryId, Note note) async {
    await dbProvider.insertNote(categoryId, NoteMapper.toDb(note));
  }

  Future<void> switchStar(List<Note> notes) async {
    final updatedNotes = notes.map((e) => e.copyWith(hasStar: !e.hasStar));
    await dbProvider.updateNotes(updatedNotes.map(NoteMapper.toDb).toList());
  }

  Future<void> deleteNotes(List<Note> notes) async {
    await dbProvider.deleteNotes(notes.map(NoteMapper.toDb).toList());
  }

  Future<void> updateNote(Note note) async {
    await dbProvider.updateNote(NoteMapper.toDb(note));
  }
}
