import '../../models/tag.dart';
import '../database/models/tag.dart';

class TagMapper {
  static Tag fromDb(DbTag dbTag) => Tag(id: dbTag.id!, name: dbTag.name);

  static DbTag toDb(Tag tag) => DbTag(id: tag.id, name: tag.name);
}
