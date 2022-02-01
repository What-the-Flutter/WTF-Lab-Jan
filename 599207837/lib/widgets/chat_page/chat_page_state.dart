import 'package:flutter/material.dart';

import '../../entity/entities.dart';

class ChatPageState {
  static const Object? _plug = Object();

  late final List<Message>? selected;
  final List<Message>? elements;
  final List<Message>? searchMessages;

  List<Message> get messages => searchMessages ?? elements ?? [];

  final IconData addedIcon;
  final String? imagePath;
  final String? imageName;
  final Topic? topic;
  final int addedType;
  final int editingIndex;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final TextEditingController? searchController;
  late final TextEditingController? descriptionController;

  final bool selectionFlag;
  final bool editingFlag;
  final bool searchPage;

  ChatPageState({
    this.selected,
    this.elements,
    this.searchMessages,
    this.selectionFlag = false,
    this.editingFlag = false,
    this.addedType = 0,
    this.addedIcon = Icons.feed_rounded,
    this.selectedDate,
    this.selectedTime,
    this.editingIndex = 0,
    this.searchPage = false,
    this.searchController,
    this.descriptionController,
    this.topic,
    this.imagePath,
    this.imageName,
  });

  ChatPageState.initial({
    this.elements,
    this.searchMessages,
    this.selectionFlag = false,
    this.editingFlag = false,
    this.addedType = 0,
    this.addedIcon = Icons.feed_rounded,
    this.selectedDate,
    this.selectedTime,
    this.editingIndex = 0,
    this.searchPage = false,
    this.searchController,
    this.topic,
    this.imagePath,
    this.imageName,
  }) {
    selected = List.empty(growable: true);
    descriptionController = TextEditingController();
  }

  ChatPageState duplicate({
    Object? elements = _plug,
    Object? searchMessages = _plug,
    bool? selectionFlag,
    bool? editingFlag,
    int? addedType,
    IconData? addedIcon,
    Object? selectedDate = _plug,
    Object? selectedTime = _plug,
    int? editingIndex,
    bool? searchPage,
    Object? searchController = _plug,
    Object? topic = _plug,
    Object? imagePath = _plug,
    Object? imageName = _plug,
  }) {
    return ChatPageState(
      selected: selected,
      elements: elements == _plug ? this.elements : elements as List<Message>?,
      searchMessages:
          searchMessages == _plug ? this.searchMessages : searchMessages as List<Message>?,
      selectionFlag: selectionFlag ?? this.selectionFlag,
      editingFlag: editingFlag ?? this.editingFlag,
      addedType: addedType ?? this.addedType,
      addedIcon: addedIcon ?? this.addedIcon,
      selectedDate: selectedDate == _plug ? this.selectedDate : selectedDate as DateTime?,
      selectedTime: selectedTime == _plug ? this.selectedTime : selectedTime as TimeOfDay?,
      editingIndex: editingIndex ?? this.editingIndex,
      searchPage: searchPage ?? this.searchPage,
      searchController: searchController == _plug
          ? this.searchController
          : searchController as TextEditingController?,
      topic: topic == _plug ? this.topic : topic as Topic?,
      descriptionController: descriptionController,
      imagePath: imagePath == _plug ? this.imagePath : imagePath as String?,
      imageName: imageName == _plug ? this.imageName : imageName as String?,
    );
  }
}
