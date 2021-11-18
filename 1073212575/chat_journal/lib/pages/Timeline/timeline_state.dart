import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/filter_parameters.dart';

class TimelinePageState {
  final List messages;
  final bool onlyMarked;
  final bool isSelected;
  final bool isSearchGoing;
  final bool isCategoryPanelOpened;
  final bool needsEditing;
  final bool isDateTimeSelected;
  final bool isColorChanged;
  final bool arePagesIgnored;
  final int selectedMessageIndex;
  final IconData categoryIcon;
  final String selectedImagePath;
  final String searchText;
  final TimeOfDay selectedTime;
  final DateTime selectedDate;
  final FilterParameters parameters;

  TimelinePageState({
    required this.messages,
    required this.onlyMarked,
    required this.isSelected,
    required this.isSearchGoing,
    required this.isCategoryPanelOpened,
    required this.needsEditing,
    required this.isDateTimeSelected,
    required this.isColorChanged,
    required this.arePagesIgnored,
    required this.selectedMessageIndex,
    required this.categoryIcon,
    required this.selectedImagePath,
    required this.searchText,
    required this.selectedTime,
    required this.selectedDate,
    required this.parameters,
  });

  TimelinePageState copyWith({
    List? messages,
    bool? onlyMarked,
    bool? isSelected,
    bool? isSearchGoing,
    bool? isCategoryPanelOpened,
    bool? needsEditing,
    bool? isDateTimeSelected,
    bool? isColorChanged,
    bool? arePagesIgnored,
    int? selectedMessageIndex,
    IconData? categoryIcon,
    String? selectedImagePath,
    String? searchText,
    TimeOfDay? selectedTime,
    DateTime? selectedDate,
    FilterParameters? parameters,
  }) {
    return TimelinePageState(
      messages: messages ?? this.messages,
      onlyMarked: onlyMarked ?? this.onlyMarked,
      isSelected: isSelected ?? this.isSelected,
      isSearchGoing: isSearchGoing ?? this.isSearchGoing,
      isCategoryPanelOpened:
          isCategoryPanelOpened ?? this.isCategoryPanelOpened,
      needsEditing: needsEditing ?? this.needsEditing,
      isDateTimeSelected: isDateTimeSelected ?? this.isDateTimeSelected,
      isColorChanged: isColorChanged ?? this.isColorChanged,
      arePagesIgnored: arePagesIgnored ?? this.arePagesIgnored,
      selectedMessageIndex: selectedMessageIndex ?? this.selectedMessageIndex,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
      searchText: searchText ?? this.searchText,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedDate: selectedDate ?? this.selectedDate,
      parameters: parameters ?? this.parameters,
    );
  }
}
