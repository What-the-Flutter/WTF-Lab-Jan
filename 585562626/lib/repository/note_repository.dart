import '../models/category.dart';
import '../models/note.dart';
import '../models/note_with_category.dart';
import '../models/tag.dart';
import 'database/database_provider.dart';
import 'mappers/note_mapper.dart';
import 'mappers/note_with_category_mapper.dart';
import 'mappers/tag_mapper.dart';

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

  Future<int> addNote(int categoryId, Note note) async {
    return dbProvider.insertNote(categoryId, NoteMapper.toDb(note));
  }

  Future<bool> switchStar(List<Note> notes) async {
    return dbProvider.updateNotes(notes.map(NoteMapper.toDb).toList());
  }

  Future<bool> deleteNotes(List<Note> notes) async {
    return dbProvider.deleteNotes(notes.map(NoteMapper.toDb).toList());
  }

  Future<int> updateNote(Note note) async {
    return dbProvider.updateNote(NoteMapper.toDb(note));
  }

  Future<int> updateNoteCategory(Category category, Note note) async {
    return dbProvider.updateNoteCategory(category.id!, note.id!);
  }

  Future<void> addTag(Tag tag) async {
    await dbProvider.insertTag(TagMapper.toDb(tag));
  }

  Future<List<Tag>> fetchTags() async {
    final dbTags = await dbProvider.tags();
    return dbTags.map(TagMapper.fromDb).toList();
  }

  Future<List<NoteWithCategory>> fetchNotesWithCategories() async {
    final dbTags = await dbProvider.notesWithCategories();
    return dbTags.map(NoteWithCategoryMapper.fromDb).toList();
  }
}
