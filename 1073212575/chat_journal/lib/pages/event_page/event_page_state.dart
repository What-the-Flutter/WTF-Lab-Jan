import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventPageState {
  final List messages;
  final bool onlyMarked;
  final bool isSelected;
  final bool isSearchGoing;
  final bool isCategoryPanelOpened;
  final bool needsEditing;
  final bool isDateTimeSelected;
  final int selectedMessageIndex;
  final IconData categoryIcon;
  final String eventPageId;
  final String selectedImagePath;
  final String searchText;
  final TimeOfDay selectedTime;
  final DateTime selectedDate;

  EventPageState({
    required this.messages,
    required this.onlyMarked,
    required this.isSelected,
    required this.isSearchGoing,
    required this.isCategoryPanelOpened,
    required this.needsEditing,
    required this.isDateTimeSelected,
    required this.selectedMessageIndex,
    required this.categoryIcon,
    required this.eventPageId,
    required this.selectedImagePath,
    required this.searchText,
    required this.selectedTime,
    required this.selectedDate,
  });

  EventPageState copyWith({
    List? messages,
    bool? onlyMarked,
    bool? isSelected,
    bool? isSearchGoing,
    bool? isCategoryPanelOpened,
    bool? needsEditing,
    bool? isDateTimeSelected,
    int? selectedMessageIndex,
    IconData? categoryIcon,
    String? eventPageId,
    String? selectedImagePath,
    String? searchText,
    TimeOfDay? selectedTime,
    DateTime? selectedDate,
  }) {
    return EventPageState(
      messages: messages ?? this.messages,
      onlyMarked: onlyMarked ?? this.onlyMarked,
      isSelected: isSelected ?? this.isSelected,
      isSearchGoing: isSearchGoing ?? this.isSearchGoing,
      isCategoryPanelOpened:
          isCategoryPanelOpened ?? this.isCategoryPanelOpened,
      needsEditing: needsEditing ?? this.needsEditing,
      isDateTimeSelected: isDateTimeSelected ?? this.isDateTimeSelected,
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
