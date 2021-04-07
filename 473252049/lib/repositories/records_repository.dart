import 'package:flutter/material.dart';

import '../model/category.dart';
import '../model/record.dart';
import 'repository.dart';

abstract class RecordsRepository implements Repository<Record> {
  Future<List<Record>> getAllFromCategory({@required int categoryId});

  Future<List<Record>> getAllRecords({int categoryId});

  Future<Category> getCategory({int categoryId});
}
