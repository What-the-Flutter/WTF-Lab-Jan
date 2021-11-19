import '../../models/category_model.dart';
import '../db/db_models/category_db_model.dart';

mixin CategoryMapper {
  static Category fromDb(CategoryDbModel categoryDb) {
    return Category(
      id: categoryDb.id!,
      icon: categoryDb.icon,
      name: categoryDb.title,
      priority: CategoryPriority.values[categoryDb.priority],
    );
  }

  static CategoryDbModel toDb(Category category, {bool isDefault = false}) {
    return CategoryDbModel(
      id: category.id,
      icon: category.icon,
      priority: category.priority.index,
      title: category.name,
      isDefault: isDefault ? 1 : 0,
    );
  }
}
