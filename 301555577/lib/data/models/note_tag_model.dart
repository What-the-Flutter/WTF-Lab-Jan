import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NoteTag extends Equatable {
  final int? id;
  final String? title;
  final IconData icon;

  NoteTag({
    this.id,
    this.title,
    required this.icon,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        icon,
      ];

  NoteTag copyWith({
    int? id,
    String? title,
    IconData? icon,
  }) {
    return NoteTag(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'icon': icon.codePoint,
    };
  }

  factory NoteTag.fromMap(Map<String, dynamic> map) {
    return NoteTag(
      id: map['id'],
      title: map['title'],
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
    );
  }
}
