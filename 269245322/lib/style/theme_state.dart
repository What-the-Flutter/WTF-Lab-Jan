import 'package:flutter/material.dart';

class ThemeState {
  final ThemeData? themeData;

  ThemeState({
    this.themeData,
  });

  ThemeState copyWith({
    final ThemeData? themeData,
  }) {
    return ThemeState(
      themeData: themeData ?? this.themeData,
    );
  }
}
