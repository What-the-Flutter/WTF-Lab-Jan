import 'package:flutter/material.dart';

import '../../entity/entities.dart';

class ChatPageState {
  List<Message> selected = List.empty(growable: true);
  late List<Message> elements;

  IconData addedIcon = Icons.feed_rounded;
  Topic? _topic;
  int addedType = 0;
  int editingIndex = 0;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController? searchController;

  bool selectionFlag = false;
  bool fullRedraw = false;
  bool formRedraw = false;
  bool appBarRedraw = false;
  bool editingFlag = false;
  bool searchPage = false;

  ChatPageState();

  void getElements(Topic topic) {
    elements = topic.getElements();
    _topic = topic;
  }

  void getElementsAgain() {
    getElements(_topic!);
  }

  void findElements() {
    getElementsAgain();
    elements = elements
        .where((element) =>
            element.description.toLowerCase().contains(searchController!.text.toLowerCase()))
        .toList();
  }

  ChatPageState duplicate() {
    return ChatPageState()
      ..selected = selected
      ..elements = elements
      ..selectionFlag = selectionFlag
      ..editingFlag = editingFlag
      ..fullRedraw = fullRedraw
      ..formRedraw = formRedraw
      ..appBarRedraw = appBarRedraw
      ..addedType = addedType
      ..addedIcon = addedIcon
      ..selectedDate = selectedDate
      ..selectedTime = selectedTime
      ..editingIndex = editingIndex
      ..searchPage = searchPage
      ..searchController = searchController
      .._topic = _topic;
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
