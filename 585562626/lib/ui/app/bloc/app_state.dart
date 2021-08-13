import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppState extends Equatable {
  final ThemeData theme;
  final bool isDarkMode;

  const AppState(this.theme, this.isDarkMode);

  @override
  List<Object?> get props => [theme];
}
