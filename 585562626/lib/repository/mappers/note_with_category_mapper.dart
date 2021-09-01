import '../../models/note_with_category.dart';
import '../database/models/note_with_category.dart';
import 'category_mapper.dart';
import 'note_mapper.dart';

class NoteWithCategoryMapper {
  static NoteWithCategory fromDb(DbNoteWithCategory dbNote) {
    return NoteWithCategory(
      note: NoteMapper.fromDb(dbNote.note),
      category: CategoryMapper.fromDb(dbNote.category),
    );
  }

  static DbNoteWithCategory toDb(NoteWithCategory note) {
    return DbNoteWithCategory(
      note: NoteMapper.toDb(note.note),
      category: CategoryMapper.toDb(note.category),
    );
  }
}
