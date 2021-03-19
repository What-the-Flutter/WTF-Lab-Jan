import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Category implements Comparable {
  int id;
  String name;
  IconData icon;
  DateTime createDateTime;
  bool isPinned;

  Category(
    this.name, {
    @required this.icon,
    this.id,
    this.createDateTime,
    this.isPinned = false,
  }) {
    createDateTime ??= DateTime.now();
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
        isPinned = map['isPinned'] == 0 ? false : true;

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
  }) {
    return Category(
      name ?? this.name,
      id: id ?? this.id,
      icon: icon ?? this.icon,
      createDateTime: createDateTime ?? this.createDateTime,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  void pin() => isPinned = true;
  void unpin() => isPinned = false;

  @override
  int compareTo(Object other) {
    if (isPinned == (other as Category).isPinned) {
      return name.compareTo((other as Category).name);
    }
    if (isPinned) return -1;
    return 1;
  }
}
