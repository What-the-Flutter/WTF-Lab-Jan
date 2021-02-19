import 'record.dart';
import 'package:flutter/material.dart';

class Category {
  String name;
  IconData icon;
  List<Record> _records;

  Category(this.name, this.icon) : _records = [];

  Category.withRecords(this.name, this.icon, this._records);

  List<Record> get records => _records;

  List<Record> get highlightedRecords =>
      _records.where((r) => r.isHighlighted).toList();

  List<Record> get favoritesRecords =>
      _records.where((r) => r.isFavorite).toList();

  void addRecord(Record record) {
    _records.insert(0, record);
  }

  void unhighlight() {
    for (var record in highlightedRecords) {
      record.isHighlighted = false;
    }
  }

  void remove(Record record) {
    _records.remove(record);
  }

  void removeRecords(List<Record> records) {
    for (var record in records) {
      _records.remove(record);
    }
  }

  void removeHighlighted() {
    removeRecords(highlightedRecords);
  }

  void changeHighlightedIsFavorite() {
    for (var record in highlightedRecords) {
      record.changeIsFavorite();
    }
  }

  void addRecordFromMessage(String recordMessage) {
    _records.add(Record(recordMessage));
  }
}
