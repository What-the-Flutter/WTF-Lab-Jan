import 'dart:io';

import 'package:flutter/material.dart';

class Record implements Comparable {
  final int id;
  String message;
  File image;
  DateTime createDateTime;
  int categoryId;

  bool isSelected;
  bool isFavorite;

  Record(
    this.message, {
    this.image,
    this.id,
    @required this.categoryId,
    this.isSelected = false,
    this.isFavorite = false,
    this.createDateTime,
  }) {
    createDateTime ??= DateTime.now();
  }

  Record.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        message = map['message'],
        createDateTime = DateTime.fromMillisecondsSinceEpoch(
          map['createDateTime'],
        ),
        categoryId = map['categoryId'],
        isSelected = false,
        isFavorite = map['isFavorite'] == 0 ? false : true {
    if (map['imageUri'] != null) {
      image = File.fromUri(
        Uri.parse(
          map['imageUri'],
        ),
      );
    } else {
      image = null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      if (image != null) 'imageUri': image.uri.toString(),
      'createDateTime': createDateTime.millisecondsSinceEpoch,
      'categoryId': categoryId,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  Record copyWith({
    int id,
    String message,
    File image,
    int categoryId,
    bool isSelected,
    bool isFavorite,
    DateTime createDateTime,
  }) {
    return Record(
      message ?? this.message,
      categoryId: categoryId ?? this.categoryId,
      image: image ?? this.image,
      id: id ?? this.id,
      isSelected: isSelected ?? this.isSelected,
      isFavorite: isFavorite ?? this.isFavorite,
      createDateTime: createDateTime ?? this.createDateTime,
    );
  }

  void select() => isSelected = true;
  void unselect() => isSelected = false;

  void favorite() => isFavorite = true;
  void unfavorite() => isFavorite = false;

  @override
  String toString() {
    return message;
  }

  @override
  int compareTo(Object other) {
    if (other is Record) {
      return other.createDateTime.compareTo(createDateTime);
    }
    return 0;
  }
}
