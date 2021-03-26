import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LabelModel implements Equatable {
  final IconData icon;
  final bool isSelected;

  LabelModel({
    this.icon,
    this.isSelected = false,
  });

  @override
  String toString() {
    return 'LabelModel{icon: $icon, isVisible: $isSelected}';
  }

  LabelModel copyWith({
    final IconData icon,
    final bool isSelected,
  }) {
    return LabelModel(
        icon: icon ?? this.icon, isSelected: isSelected ?? isSelected);
  }

  @override
  List<Object> get props => [icon, isSelected];

  @override
  bool get stringify => throw UnimplementedError();
}
