import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CategoryIcon implements Equatable {
  final IconData icon;
  final String title;

  CategoryIcon({this.icon, this.title});

  @override
  String toString() {
    return 'CategoryModel{icon: $icon, isVisible: $title}';
  }

  CategoryIcon copyWith({
    final IconData icon,
    final String title,
  }) {
    return CategoryIcon(
        icon: icon ?? this.icon, title: title ?? this.title);
  }

  @override
  List<Object> get props => [icon, title];

  @override
  bool get stringify => throw UnimplementedError();
}
