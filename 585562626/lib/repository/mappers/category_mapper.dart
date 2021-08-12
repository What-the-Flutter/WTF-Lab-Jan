import 'dart:ui';

import '../../models/category.dart';
import '../database/models/category.dart';

class CategoryMapper {
  static NoteCategory fromDb(DbCategory dbCategory) {
    return NoteCategory(
      id: dbCategory.id!,
      color: Color(dbCategory.color),
      image: dbCategory.image,
      name: dbCategory.name,
      priority: CategoryPriority.values[dbCategory.priority],
    );
  }

  static DbCategory toDb(NoteCategory category, {bool isDefault = false}) {
    return DbCategory(
      id: category.id,
      color: category.color.value,
      image: category.image,
      priority: category.priority.index,
      name: category.name,
      isDefault: isDefault ? 1 : 0
    );
  }
}
