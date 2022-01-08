import 'package:flutter/material.dart';

import '../../entity/entities.dart';

class ChatPageState {
  List<Message> selected = List.empty(growable: true);
  late final List<Message> elements;

  IconData addedIcon = Icons.feed_rounded;
  int addedType = 0;
  int editingIndex = 0;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool _dateTimeChanged = false;

  bool selectionFlag = false;
  bool needToRedraw = false;
  bool editingFlag = false;

  ChatPageState();

  bool get dateTimeChanged {
    if (_dateTimeChanged) {
      _dateTimeChanged = false;
      return true;
    }
    return false;
  }

  set dateTimeChanged(bool v) => _dateTimeChanged = v;

  void getElements(Topic topic) {
    elements = topic.getElements();
  }

  ChatPageState duplicate() {
    return ChatPageState()
      ..selected = selected
      ..elements = elements
      ..selectionFlag = selectionFlag
      ..editingFlag = editingFlag
      ..needToRedraw = needToRedraw
      ..addedType = addedType
      ..addedIcon = addedIcon
      ..selectedDate = selectedDate
      ..selectedTime = selectedTime
      ..dateTimeChanged = _dateTimeChanged
      ..editingIndex = editingIndex;
  }

  void changeAddedType() {
    addedType = (addedType + 1) % 3;
    addedIcon = addedType == 0
        ? Icons.feed_rounded
        : (addedType == 1 ? Icons.event_rounded : Icons.drive_file_rename_outline);
  }

  void changeAddedTypeTo(int i) {
    if (addedType != i) {
      addedType = i;
      addedIcon = addedType == 0
          ? Icons.feed_rounded
          : (addedType == 1 ? Icons.event_rounded : Icons.drive_file_rename_outline);
    }
  }
}
