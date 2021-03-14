import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../models/event_message.dart';
import '../../models/suggestion.dart';
import '../../models/tag.dart';

class EventScreenState {
  final Suggestion listViewSuggestion;
  List<EventMessage> filteredEventMessageList;
  List<EventMessage> eventMessageList;
  EventMessage selectedEventMessage;
  File imageFile;
  Category selectedCategory;
  bool isSearchIconButtonPressed;
  bool isWriting;
  bool isFavoriteButPressed;
  bool isEditing;
  bool isCategorySelected;
  DateTime selectedDate;
  TimeOfDay selectedTime;
  List<Tag> tagList;

  EventScreenState(
    this.listViewSuggestion,
    this.filteredEventMessageList,
    this.eventMessageList,
    this.selectedEventMessage,
    this.imageFile,
    this.selectedCategory,
    this.isSearchIconButtonPressed,
    this.isWriting,
    this.isFavoriteButPressed,
    this.isEditing,
    this.isCategorySelected,
    this.selectedDate,
    this.selectedTime,
    this.tagList,
  );

  EventScreenState copyWith({
    final Suggestion listViewSuggestion,
    final List<EventMessage> filteredEventMessageList,
    final List<EventMessage> eventMessageList,
    final EventMessage selectedEventMessage,
    final File imageFile,
    final Category selectedCategory,
    final bool isSearchIconButtonPressed,
    final bool isWriting,
    final bool isFavoriteButPressed,
    final bool isEditing,
    final bool isCategorySelected,
    final DateTime selectedDate,
    final TimeOfDay selectedTime,
    final List<Tag> tagList,
  }) {
    return EventScreenState(
      listViewSuggestion ?? this.listViewSuggestion,
      filteredEventMessageList ?? this.filteredEventMessageList,
      eventMessageList ?? this.eventMessageList,
      selectedEventMessage ?? this.selectedEventMessage,
      imageFile ?? this.imageFile,
      selectedCategory ?? this.selectedCategory,
      isSearchIconButtonPressed ?? this.isSearchIconButtonPressed,
      isWriting ?? this.isWriting,
      isFavoriteButPressed ?? this.isFavoriteButPressed,
      isEditing ?? this.isEditing,
      isCategorySelected ?? this.isCategorySelected,
      selectedDate ?? this.selectedDate,
      selectedTime ?? this.selectedTime,
      tagList ?? this.tagList,
    );
  }
}
