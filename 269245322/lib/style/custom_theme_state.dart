import 'package:flutter/material.dart';

class ThemeState {
  late final ThemeData? theme;

  ThemeState({
    this.theme,
  });

  ThemeState copyWith({
    final ThemeData? theme,
  }) {
    return ThemeState(
      theme: theme ?? this.theme,
    );
  }
}
