import '../models/category.dart';

class IconsRepository {
  final List<Categories> _list = Categories.values;

  List<Categories> get list => _list;
}
