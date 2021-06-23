import '../models/category.dart';
import '../services/databases/db_category.dart';

class HomeRepository {
  final DBProvider db = DBProvider.instance;
  final _list = <Category>[];

  List<Category> get list => _list;

  Future<List<Category>> getAll() async {
    final listFromDB = await db.getAllCategories();
    _list.addAll(listFromDB);
    return _list;
  }

  Future<void> add(Category category) async {
    _list.add(category);
    await db.addCategory(category);
  }

  Future<void> delete(String id) async {
    _list.removeWhere((element) => element.id == id);
    await db.deleteCategory(id);
  }

  Future<void> update(
    Category category,
    String title,
    String description,
    Categories categories,
  ) async {
    final updatedCategory = category.copyWith(
      title: title,
      description: description,
      categories: categories,
      assetImage: categories.img,
    );
    final index = _list.indexWhere((element) => element.id == category.id);
    _list[index] = updatedCategory;
    await db.updateCategory(updatedCategory);
  }

  Future<void> pin(Category category) async {
    final index = _list.indexWhere((element) => element.id == category.id);
    final pinned = category.copyWith(isPin: !category.isPin);
    _list[index] = pinned;
    await db.pinCategory(pinned);
  }
}
