import '../../models/note_model.dart';
import '../db/db_models/note_db_model.dart';

mixin NoteMapper {
  static Note fromDb(NoteDbModel dbNote) {
    return Note(
      text: dbNote.text,
      image: dbNote.image,
      id: dbNote.id!,
      hasStar: dbNote.hasStar == 1,
      created: DateTime.fromMillisecondsSinceEpoch(dbNote.created),
      updated: dbNote.updated == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(dbNote.updated!),
    );
  }

  static NoteDbModel toDb(Note note) {
    return NoteDbModel(
      id: note.id,
      created: note.created.millisecondsSinceEpoch,
      hasStar: note.hasStar ? 1 : 0,
      updated: note.updated?.millisecondsSinceEpoch,
      text: note.text,
      image: note.image,
    );
  }
}
