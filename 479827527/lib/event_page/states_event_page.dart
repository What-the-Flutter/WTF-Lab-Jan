import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../event.dart';

class StatesEventPage {
  TextEditingController textController = TextEditingController();
  TextEditingController textSearchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  FocusNode focusSearchNode = FocusNode();
  final List<IconData> bottomSheetButtons = [
    Icons.clear,
    Icons.airplanemode_active,
    Icons.fastfood,
    Icons.sports_basketball,
    Icons.search,
    Icons.home,
    Icons.family_restroom,
    Icons.car_rental,
    Icons.school_sharp,
  ];

  List<Event> currentEventsList;
  IconData selectedIcon;
  bool isEventSelected = false;
  bool isEditing = false;
  bool isSearch = false;
  int selectedItemIndex = 0;
  int selectedPageReplyIndex = 0;

  StatesEventPage copyWith({
    List<Event> currentEventsList,
    IconData selectedIcon,
    bool isEventSelected,
    bool isEditing,
    bool isSearch,
    int selectedItemIndex,
    int selectedPageReplyIndex,
  }) {
    var state = StatesEventPage(currentEventsList ?? this.currentEventsList);
    state.textController = textController;
    state.focusNode = focusNode;
    state.textSearchController = textSearchController;
    state.focusSearchNode = focusSearchNode;
    state.selectedIcon = selectedIcon ?? this.selectedIcon;
    state.isEventSelected = isEventSelected ?? this.isEventSelected;
    state.isEditing = isEditing ?? this.isEditing;
    state.isSearch = isSearch ?? this.isSearch;
    state.selectedItemIndex = selectedItemIndex ?? this.selectedItemIndex;
    state.selectedPageReplyIndex =
        selectedPageReplyIndex ?? this.selectedPageReplyIndex;
    return state;
  }

  StatesEventPage(this.currentEventsList);
}
