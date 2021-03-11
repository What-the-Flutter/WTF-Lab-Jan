import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LabelIcon implements Equatable {
  final IconData icon;
  final bool isVisible;

  LabelIcon({this.icon, this.isVisible = false});

  @override
  String toString() {
    return 'LabelModel{icon: $icon, isVisible: $isVisible}';
  }

  LabelIcon copyWith({
    final IconData icon,
    final bool isVisible,
  }) {
    return LabelIcon(
        icon: icon ?? this.icon, isVisible: isVisible ?? this.isVisible);
  }

  @override
  List<Object> get props => [icon, isVisible];

  @override
  bool get stringify => throw UnimplementedError();
}
