import 'record.dart';
import 'package:flutter/material.dart';

class Category {
  String name;
  IconData icon;
  List<Record> _records;

  Category(this.name, this.icon) : _records = [];

  Category.withRecords(this.name, this.icon, this._records);

  List<Record> get records => _records;

  void addRecord(Record record) {
    _records.add(record);
  }

  void removeRecord(Record record) {
    _records.remove(record);
  }

  void addRecordFromMessage(String recordMessage) {
    _records.add(Record(recordMessage));
  }
}
