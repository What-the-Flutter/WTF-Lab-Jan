import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventPageState {
  final List labels;
  final List hashTags;
  final List messages;
  final bool onlyMarked;
  final bool isSelected;
  final bool isSearchGoing;
  final bool isLabelPanelOpened;
  final bool isHashTagPanelVisible;
  final bool needsEditing;
  final bool isDateTimeSelected;
  final bool isColorChanged;
  final int selectedMessageIndex;
  final IconData selectedLabelIcon;
  final String eventPageId;
  final String selectedImagePath;
  final String searchText;
  final TimeOfDay selectedTime;
  final DateTime selectedDate;

  EventPageState({
    required this.labels,
    required this.hashTags,
    required this.messages,
    required this.onlyMarked,
    required this.isSelected,
    required this.isSearchGoing,
    required this.isLabelPanelOpened,
    required this.isHashTagPanelVisible,
    required this.needsEditing,
    required this.isDateTimeSelected,
    required this.isColorChanged,
    required this.selectedMessageIndex,
    required this.selectedLabelIcon,
    required this.eventPageId,
    required this.selectedImagePath,
    required this.searchText,
    required this.selectedTime,
    required this.selectedDate,
  });

  EventPageState copyWith({
    List? labels,
    List? hashTags,
    List? messages,
    bool? onlyMarked,
    bool? isSelected,
    bool? isSearchGoing,
    bool? isLabelPanelOpened,
    bool? isHashTagPanelVisible,
    bool? needsEditing,
    bool? isDateTimeSelected,
    bool? isColorChanged,
    int? selectedMessageIndex,
    IconData? selectedLabelIcon,
    String? eventPageId,
    String? selectedImagePath,
    String? searchText,
    TimeOfDay? selectedTime,
    DateTime? selectedDate,
  }) {
    return EventPageState(
      labels: labels ?? this.labels,
      hashTags: hashTags ?? this.hashTags,
      messages: messages ?? this.messages,
      onlyMarked: onlyMarked ?? this.onlyMarked,
      isSelected: isSelected ?? this.isSelected,
      isSearchGoing: isSearchGoing ?? this.isSearchGoing,
      isLabelPanelOpened: isLabelPanelOpened ?? this.isLabelPanelOpened,
      isHashTagPanelVisible:
          isHashTagPanelVisible ?? this.isHashTagPanelVisible,
      needsEditing: needsEditing ?? this.needsEditing,
      isDateTimeSelected: isDateTimeSelected ?? this.isDateTimeSelected,
      isColorChanged: isColorChanged ?? this.isColorChanged,
      selectedMessageIndex: selectedMessageIndex ?? this.selectedMessageIndex,
      selectedLabelIcon: selectedLabelIcon ?? this.selectedLabelIcon,
      eventPageId: eventPageId ?? this.eventPageId,
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
      searchText: searchText ?? this.searchText,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
