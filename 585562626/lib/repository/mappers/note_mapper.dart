import '../../models/note.dart';
import '../database/models/note.dart';

class NoteMapper {
  static Note fromDb(DbNote dbNote) {
    return Note(
      text: dbNote.text,
      image: dbNote.image,
      id: dbNote.id!,
      direction: AlignDirection.values[dbNote.direction],
      hasStar: dbNote.hasStar == 1,
      created: DateTime.fromMillisecondsSinceEpoch(dbNote.created),
      updated: dbNote.updated == null ? null : DateTime.fromMillisecondsSinceEpoch(dbNote.updated!),
    );
  }

  static DbNote toDb(Note note) {
    return DbNote(
      id: note.id,
      created: note.created.millisecondsSinceEpoch,
      direction: note.direction.index,
      hasStar: note.hasStar ? 1 : 0,
      updated: note.updated?.millisecondsSinceEpoch,
      text: note.text,
      image: note.image,
    );
  }
}
