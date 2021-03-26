import 'package:flutter/material.dart';

class StatesCreatePage {
  CircleAvatar selectedIcon;

  StatesCreatePage(this.selectedIcon);

  StatesCreatePage copyWith({
    CircleAvatar selectedIcon,
  }) {
    return StatesCreatePage(selectedIcon ?? this.selectedIcon);
  }
}
