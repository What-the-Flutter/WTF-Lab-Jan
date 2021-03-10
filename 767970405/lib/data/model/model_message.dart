import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ModelMessage extends Equatable {
  final bool isFavor;
  final bool isSelected;
  final String data;

  ModelMessage({
    this.isFavor,
    this.isSelected,
    this.data,
  });

  Widget get message;

  ModelMessage copyWith({
    final String data,
    final bool isFavor,
    final bool isSelected,
  });

  @override
  String toString() {
    return 'ModelMessage{isFavor: $isFavor, isSelected: $isSelected, data: $data}\n';
  }
}

class TextMessage extends ModelMessage {
  TextMessage({
    String data,
    bool isFavor,
    bool isSelected,
  }) : super(
          data: data,
          isFavor: isFavor,
          isSelected: isSelected,
        );

  @override
  ModelMessage copyWith({
    final String data,
    final bool isFavor,
    final bool isSelected,
  }) {
    return TextMessage(
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
    String data,
    bool isFavor,
    bool isSelected,
  }) : super(
          data: data,
          isFavor: isFavor,
          isSelected: isSelected,
        );

  @override
  ModelMessage copyWith({
    final String data,
    final bool isFavor,
    final bool isSelected,
  }) {
    return ImageMessage(
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
