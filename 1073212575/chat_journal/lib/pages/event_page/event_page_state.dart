import 'package:flutter/cupertino.dart';

class EventPageState {
  final List messages;
  final bool onlyMarked;
  final bool isSelected;
  final bool isSearchGoing;
  final bool isCategoryPanelOpened;
  final bool needsEditing;
  final int selectedMessageIndex;
  final IconData? categoryIcon;

  EventPageState({
    required this.messages,
    required this.onlyMarked,
    required this.isSelected,
    required this.isSearchGoing,
    required this.isCategoryPanelOpened,
    required this.needsEditing,
    required this.selectedMessageIndex,
    required this.categoryIcon,
  });

  EventPageState copyWith({
    List? messages,
    bool? onlyMarked,
    bool? isSelected,
    bool? isSearchGoing,
    bool? isCategoryPanelOpened,
    bool? needsEditing,
    int? selectedMessageIndex,
    IconData? categoryIcon,
  }) {
    return EventPageState(
      messages: messages ?? this.messages,
      onlyMarked: onlyMarked ?? this.onlyMarked,
      isSelected: isSelected ?? this.isSelected,
      isSearchGoing: isSearchGoing ?? this.isSearchGoing,
      isCategoryPanelOpened:
          isCategoryPanelOpened ?? this.isCategoryPanelOpened,
      needsEditing: needsEditing ?? this.needsEditing,
      selectedMessageIndex: selectedMessageIndex ?? this.selectedMessageIndex,
      categoryIcon: categoryIcon ?? this.categoryIcon,
    );
  }
}
