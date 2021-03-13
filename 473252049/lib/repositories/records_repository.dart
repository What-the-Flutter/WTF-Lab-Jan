import 'package:chat_journal/model/record.dart';
import 'package:chat_journal/repositories/repository.dart';
import 'package:flutter/material.dart';

abstract class RecordsRepository implements Repository<Record> {
  Future<List<Record>> getAllFromCategory({@required int categoryId});

  Future<List<Record>> getAllRecords({int categoryId});
}
