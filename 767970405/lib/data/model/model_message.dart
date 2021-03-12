import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ModelMessage extends Equatable {
  final int id;
  final int pageId;
  final bool isFavor;
  final bool isSelected;
  final String data;

  ModelMessage({
    this.id,
    this.pageId,
    this.isFavor,
    this.isSelected,
    this.data,
  });

  Widget get message;

  ModelMessage copyWith({
    final int id,
    final int pageId,
    final String data,
    final bool isFavor,
    final bool isSelected,
  });

  @override
  String toString() {
    return 'ModelMessage{isFavor: $isFavor, isSelected: $isSelected, data: $data}\n';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pageId': pageId,
      'isFavor': isFavor ? 1 : 0,
      'isSelected': isSelected ? 1 : 0,
      'data': data,
    };
  }
}

class TextMessage extends ModelMessage {
  TextMessage({
    int id,
    int pageId,
    String data,
    bool isFavor,
    bool isSelected,
  }) : super(
          id: id,
          pageId: pageId,
          data: data,
          isFavor: isFavor,
          isSelected: isSelected,
        );

  @override
  ModelMessage copyWith({
    final int id,
    final int pageId,
    final String data,
    final bool isFavor,
    final bool isSelected,
  }) {
    return TextMessage(
      id: id ?? this.id,
      pageId: pageId ?? this.pageId,
      data: data ?? this.data,
      isFavor: isFavor ?? this.isFavor,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  Widget get message => Text(data);

  @override
  List<Object> get props => [data, isSelected, isFavor];
}

class ImageMessage extends ModelMessage {
  ImageMessage({
    int id,
    int pageId,
    String data,
    bool isFavor,
    bool isSelected,
  }) : super(
          id: id,
          pageId: pageId,
          data: data,
          isFavor: isFavor,
          isSelected: isSelected,
        );

  @override
  ModelMessage copyWith({
    final int id,
    final int pageId,
    final String data,
    final bool isFavor,
    final bool isSelected,
  }) {
    return ImageMessage(
      id: id ?? this.id,
      pageId: pageId ?? this.pageId,
      data: data ?? this.data,
      isFavor: isFavor ?? this.isFavor,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  Widget get message => Image.file(File(data));

  @override
  List<Object> get props => [isFavor, isSelected, data];
}
