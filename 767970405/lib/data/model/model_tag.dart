import 'package:flutter/material.dart';

@immutable
class ModelTag {
  final int id;
  final String name;
  final bool isSelected;

  ModelTag({
    this.id,
    this.name,
    this.isSelected,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ModelTag &&
              runtimeType == other.runtimeType &&
              name == other.name;

  @override
  int get hashCode => name.hashCode;

  ModelTag copyWith({
    final int id,
    final String name,
    final bool isSelected,
  }) {
    return ModelTag(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
