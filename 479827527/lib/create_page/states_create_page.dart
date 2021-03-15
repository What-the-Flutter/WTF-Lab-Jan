import 'package:flutter/material.dart';

class StatesCreatePage {
  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();
  IconData selectedIcon;

  StatesCreatePage(this.selectedIcon);

  StatesCreatePage copyWith({
    TextEditingController textController,
    FocusNode focusNode,
    IconData selectedIcon,
  }) {
    var state = StatesCreatePage(selectedIcon ?? this.selectedIcon);
    state.textController = textController ?? this.textController;
    state.focusNode = focusNode ?? this.focusNode;
    return state;
  }
}
