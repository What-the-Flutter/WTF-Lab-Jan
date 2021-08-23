import 'package:flutter/material.dart';

abstract class MainEvent {}

class MainChangePageEvent extends MainEvent {
  final int index;
  MainChangePageEvent(this.index);
}

class MainState {
  final Widget? currentPage;
  final int? currentIndex;

  MainState({this.currentPage, this.currentIndex});

  MainState copyWith({Widget? currentPage, int? currentIndex}) {
    return MainState(
      currentPage: currentPage ?? this.currentPage,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
