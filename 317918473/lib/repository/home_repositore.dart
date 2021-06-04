import 'package:equatable/equatable.dart';

import '../models/category.dart';

class HomeRepository extends Equatable {
  final List<Category> _list = [];

  List<Category> get list => _list;

  void add(Category category) {
    _list.add(category);
  }

  void delete(int index) {
    _list.removeAt(index);
  }

  void update(int index, String title, String desc, Categories categories) {
    _list[index] = _list[index].copyWith(
        assetImage: categories.img,
        descripton: desc,
        title: title,
        categories: categories);
  }

  void pin(int index) {
    _list[index] = _list[index].copyWith(isPin: !_list[index].isPin);
  }

  @override
  List<Object> get props => [_list];
}
