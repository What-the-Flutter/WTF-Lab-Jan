import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../extensions/list_get_element.dart';
import '../model/record.dart';

class Category implements Comparable {
  int id;
  String name;
  IconData icon;
  List<Record> records;
  DateTime createDateTime;
  bool isPinned;

  Category(
    this.name, {
    @required this.icon,
    this.records,
    this.id,
    this.createDateTime,
    this.isPinned = false,
  }) {
    createDateTime ??= DateTime.now();
    records ??= [];
  }

  Category.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        icon = IconData(
          map['iconCodePoint'],
          fontFamily: 'MaterialIcons',
        ),
        createDateTime = DateTime.fromMillisecondsSinceEpoch(
          map['createDateTime'],
        ),
        isPinned = map['isPinned'] == 0 ? false : true,
        records = [];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconCodePoint': icon.codePoint,
      'createDateTime': createDateTime.millisecondsSinceEpoch,
      'isPinned': isPinned ? 1 : 0,
    };
  }

  Category copyWith({
    int id,
    String name,
    IconData icon,
    DateTime createDateTime,
    bool isPinned,
    List<Record> records,
  }) {
    return Category(
      name ?? this.name,
      id: id ?? this.id,
      icon: icon ?? this.icon,
      createDateTime: createDateTime ?? this.createDateTime,
      isPinned: isPinned ?? this.isPinned,
      records: records ?? this.records,
    );
  }

  List<Record> get selectedRecords {
    return records.where((r) => r.isSelected).toList();
  }

  bool get hasSelectedRecords {
    if (records.isEmpty) return false;
    return records.where((r) => r.isSelected).isNotEmpty;
  }

  void pin() => isPinned = true;
  void unpin() => isPinned = false;

  void add(Record record) {
    records.insert(0, record);
  }

  void delete(Record record) {
    records.remove(record);
  }

  void deleteAll(List<Record> records) {
    for (var record in records) {
      delete(record);
    }
  }

  Record update(Record record, {@required String newMessage, File newImage}) {
    return records.get(record)
      ..message = newMessage
      ..image = newImage;
  }

  void select(Record record) {
    records.get(record).select();
  }

  void unselect(Record record) {
    records.get(record).unselect();
  }

  void unselectAll() {
    for (var r in selectedRecords) {
      r.unselect();
    }
  }

  void favorite(Record record) {
    records.get(record).favorite();
  }

  void unfavorite(Record record) {
    records.get(record).unfavorite();
  }

  void changeFavorite(Record record) {
    if (record.isFavorite) {
      records.get(record).unfavorite();
    } else {
      records.get(record).favorite();
    }
  }

  void sort() {
    records.sort();
  }

  @override
  int compareTo(Object other) {
    if (isPinned == (other as Category).isPinned) {
      return name.compareTo((other as Category).name);
    }
    if (isPinned) return -1;
    return 1;
  }
}
