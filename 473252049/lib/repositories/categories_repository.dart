import 'package:flutter/material.dart';

import '../model/category.dart';
import '../model/record.dart';
import 'repository.dart';

abstract class CategoriesRepository implements Repository<Category> {
  Future<Record> getLastRecord({@required int categoryId});
}
