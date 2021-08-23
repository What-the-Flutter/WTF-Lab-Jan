import '../database_provider.dart';
import 'category.dart';
import 'note.dart';

class DbNoteWithCategory {
  final DbNote note;
  final DbCategory category;

  DbNoteWithCategory({
    required this.note,
    required this.category,
  });

  factory DbNoteWithCategory.fromMap(Map<String, dynamic> map) {
    return DbNoteWithCategory(
      note: DbNote(
        id: map['${DbProvider.notePrefix}id'],
        created: map['${DbProvider.notePrefix}created'],
        direction: map['${DbProvider.notePrefix}direction'],
        hasStar: map['${DbProvider.notePrefix}hasStar'],
        updated: map['${DbProvider.notePrefix}updated'],
        text: map['${DbProvider.notePrefix}text'],
        image: map['${DbProvider.notePrefix}image'],
      ),
      category: DbCategory(
        id: map['${DbProvider.categoryPrefix}id'],
        name: map['${DbProvider.categoryPrefix}name'],
        color: map['${DbProvider.categoryPrefix}color'],
        image: map['${DbProvider.categoryPrefix}image'],
        priority: map['${DbProvider.categoryPrefix}priority'],
        isDefault: map['${DbProvider.categoryPrefix}isDefault'],
      ),
    );
  }
}
