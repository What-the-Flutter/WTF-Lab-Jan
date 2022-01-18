import 'package:flutter/material.dart';

import '../../entity/entities.dart' as entity;

class ChatPageState {
  static const Object? plug = Object();

  late final List<entity.Message>? selected;
  final List<entity.Message>? elements;

  final IconData addedIcon;
  final entity.Topic? topic;
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
  });

  ChatPageState.initial({
    this.elements,
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
  }) {
    selected = List.empty(growable: true);
    descriptionController = TextEditingController();
  }

  ChatPageState duplicate({
    Object? elements = plug,
    bool? selectionFlag,
    bool? editingFlag,
    int? addedType,
    IconData? addedIcon,
    Object? selectedDate = plug,
    Object? selectedTime = plug,
    int? editingIndex,
    bool? searchPage,
    Object? searchController = plug,
    Object? topic = plug,
  }) {
    return ChatPageState(
      selected: selected,
      elements: elements == plug ? this.elements : elements as List<entity.Message>?,
      selectionFlag: selectionFlag ?? this.selectionFlag,
      editingFlag: editingFlag ?? this.editingFlag,
      addedType: addedType ?? this.addedType,
      addedIcon: addedIcon ?? this.addedIcon,
      selectedDate: selectedDate == plug ? this.selectedDate : selectedDate as DateTime?,
      selectedTime: selectedTime == plug ? this.selectedTime : selectedTime as TimeOfDay?,
      editingIndex: editingIndex ?? this.editingIndex,
      searchPage: searchPage ?? this.searchPage,
      searchController: searchController == plug
          ? this.searchController
          : searchController as TextEditingController?,
      topic: topic == plug ? this.topic : topic as entity.Topic?,
      descriptionController: descriptionController,
    );
  }
}
