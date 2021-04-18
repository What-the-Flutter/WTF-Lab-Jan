import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ModelMessage extends Equatable implements Comparable<ModelMessage> {
  final int id;
  final int pageId;
  final bool isFavor;
  final bool isSelected;
  final String text;
  final String photo;
  final int indexCategory;
  final DateTime pubTime;

  ModelMessage({
    this.id,
    this.pageId,
    this.isFavor,
    this.isSelected,
    this.text,
    this.photo,
    this.indexCategory,
    this.pubTime,
  });

  ModelMessage copyWith({
    final int id,
    final int pageId,
    final String text,
    final String photo,
    final int indexCategory,
    final DateTime pubTime,
    final bool isFavor,
    final bool isSelected,
  }) {
    return ModelMessage(
      id: id ?? this.id,
      pageId: pageId ?? this.pageId,
      text: text ?? this.text,
      photo: photo ?? this.photo,
      indexCategory: indexCategory ?? this.indexCategory,
      isSelected: isSelected ?? this.isSelected,
      isFavor: isFavor ?? this.isFavor,
      pubTime: pubTime ?? this.pubTime,
    );
  }

  @override
  String toString() {
    return '\nModelMessage{isFavor: $isFavor,'
        ' isSelected: $isSelected, data: $text}\n';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pageId': pageId,
      'isFavor': isFavor ? 1 : 0,
      'isSelected': isSelected ? 1 : 0,
      'text': text,
      'photo': photo,
      'indexCategory': indexCategory,
      'pubTime': pubTime.toString(),
    };
  }

  @override
  List<Object> get props => [
        isFavor,
        isSelected,
        text,
        photo,
        indexCategory,
        pubTime,
      ];

  @override
  int compareTo(ModelMessage other) {
    if (pubTime.isBefore(other.pubTime)) {
      return -1;
    } else {
      return 1;
    }
  }
}
