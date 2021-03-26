import 'package:flutter/material.dart';

import '../event.dart';


class StatesEventPage {
  int indexOfSelectedElement = 0;
  int selectedIndex = 0;
  bool isEditing = false;
  List<Event> eventList ;
  bool isSearch = false;
  List<Event> newEventList ;
  CircleAvatar selectedCircleAvatar;

  StatesEventPage(this.eventList);

  StatesEventPage copyWith({
    List<Event> eventList,
    int indexOfSelectedElement,
    bool isEditing,
    bool isSearch,
    int selectedIndex,
    CircleAvatar selectedCircleAvatar,
    List<Event> newEventList,
  }) {
    var state = StatesEventPage(eventList ?? this.eventList);
    state.selectedCircleAvatar= selectedCircleAvatar ?? this.selectedCircleAvatar;
    state.selectedIndex= selectedIndex ?? this.selectedIndex;
    state.newEventList = newEventList ?? this.newEventList;
    state.isEditing = isEditing ?? this.isEditing;
    state.isSearch = isSearch ?? this.isSearch;
    state.indexOfSelectedElement = indexOfSelectedElement ?? this.indexOfSelectedElement;
    return state;
  }
}