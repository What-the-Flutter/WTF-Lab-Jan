import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../extensions/list_get_element.dart';
import '../model/record.dart';

class Category extends Equatable implements Comparable {
  String name;
  IconData icon;
  List<Record> records;
  bool isSelected = false;
  bool isPinned = false;

  Category(this.name, {@required this.icon, this.records}) {
    records ??= [];
  }

  List<Record> get selectedRecords {
    return records.where((r) => r.isSelected).toList();
  }

  bool get hasSelectedRecords {
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

  @override
  int get hashCode => name.hashCode;

  @override
  List<Object> get props => [name];

  @override
  bool operator ==(Object other) {
    if (other is Category) {
      return name == other.name;
    }
    return false;
  }
}
