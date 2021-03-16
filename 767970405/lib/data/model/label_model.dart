import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LabelModel implements Equatable {
  final IconData icon;
  final bool isVisible;

  LabelModel({
    this.icon,
    this.isVisible = false,
  });

  @override
  String toString() {
    return 'LabelModel{icon: $icon, isVisible: $isVisible}';
  }

  LabelModel copyWith({
    final IconData icon,
    final bool isVisible,
  }) {
    return LabelModel(
        icon: icon ?? this.icon, isVisible: isVisible ?? this.isVisible);
  }

  @override
  List<Object> get props => [icon, isVisible];

  @override
  bool get stringify => throw UnimplementedError();
}
