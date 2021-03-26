import 'package:flutter/material.dart';

import '../note.dart';

class StatesHomePage{
  bool themeSwitcher = false;
  List<Note> noteList = [
    Note(
      'Sport',
      CircleAvatar(
        child: Icon(
          Icons.sports_soccer,
        ),
      ),
      '',
    ),
    Note(
      'FastFood',
      CircleAvatar(
        child: Icon(
          Icons.fastfood,
        ),
      ),
      '',
    ),
  ];

  StatesHomePage();

  StatesHomePage copyWith({
    bool themeSwitcher,
    List<Note> noteList,
  }) {
    var state = StatesHomePage();
    state.themeSwitcher = themeSwitcher ?? this.themeSwitcher;
    state.noteList = noteList ?? this.noteList;
    return state;
  }
}