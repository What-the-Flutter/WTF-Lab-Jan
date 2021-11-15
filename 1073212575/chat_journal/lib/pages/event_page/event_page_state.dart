import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventPageState {
  final List hashTags;
  final List messages;
  final bool onlyMarked;
  final bool isSelected;
  final bool isSearchGoing;
  final bool isCategoryPanelOpened;
  final bool isHashTagPanelVisible;
  final bool needsEditing;
  final bool isDateTimeSelected;
  final bool isColorChanged;
  final int selectedMessageIndex;
  final IconData categoryIcon;
  final String eventPageId;
  final String selectedImagePath;
  final String searchText;
  final TimeOfDay selectedTime;
  final DateTime selectedDate;

  EventPageState({
    required this.hashTags,
    required this.messages,
    required this.onlyMarked,
    required this.isSelected,
    required this.isSearchGoing,
    required this.isCategoryPanelOpened,
    required this.isHashTagPanelVisible,
    required this.needsEditing,
    required this.isDateTimeSelected,
    required this.isColorChanged,
    required this.selectedMessageIndex,
    required this.categoryIcon,
    required this.eventPageId,
    required this.selectedImagePath,
    required this.searchText,
    required this.selectedTime,
    required this.selectedDate,
  });

  EventPageState copyWith({
    List? hashTags,
    List? messages,
    bool? onlyMarked,
    bool? isSelected,
    bool? isSearchGoing,
    bool? isCategoryPanelOpened,
    bool? isHashTagPanelVisible,
    bool? needsEditing,
    bool? isDateTimeSelected,
    bool? isColorChanged,
    int? selectedMessageIndex,
    IconData? categoryIcon,
    String? eventPageId,
    String? selectedImagePath,
    String? searchText,
    TimeOfDay? selectedTime,
    DateTime? selectedDate,
  }) {
    return EventPageState(
      hashTags: hashTags ?? this.hashTags,
      messages: messages ?? this.messages,
      onlyMarked: onlyMarked ?? this.onlyMarked,
      isSelected: isSelected ?? this.isSelected,
      isSearchGoing: isSearchGoing ?? this.isSearchGoing,
      isCategoryPanelOpened:
          isCategoryPanelOpened ?? this.isCategoryPanelOpened,
      isHashTagPanelVisible:
          isHashTagPanelVisible ?? this.isHashTagPanelVisible,
      needsEditing: needsEditing ?? this.needsEditing,
      isDateTimeSelected: isDateTimeSelected ?? this.isDateTimeSelected,
      isColorChanged: isColorChanged ?? this.isColorChanged,
      selectedMessageIndex: selectedMessageIndex ?? this.selectedMessageIndex,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      eventPageId: eventPageId ?? this.eventPageId,
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
      searchText: searchText ?? this.searchText,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
