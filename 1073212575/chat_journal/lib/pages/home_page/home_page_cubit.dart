import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/events.dart';
import '../add_page/add_page_screen.dart';
import 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit()
      : super(
          HomePageState(
            isSelected: false,
            selectedPageIndex: 0,
          ),
        );

  void select(int i) {
    emit(state.copyWith(
      selectedPageIndex: i,
      isSelected: true,
    ));
  }

  void unselect() {
    emit(state.copyWith(
      selectedPageIndex: state.selectedPageIndex,
      isSelected: false,
    ));
  }

  void delete() {
    eventPages.removeAt(state.selectedPageIndex);
    emit(state.copyWith(
      selectedPageIndex: state.selectedPageIndex,
      isSelected: false,
    ));
  }

  void edit(BuildContext context) {
    emit(state.copyWith(
      selectedPageIndex: state.selectedPageIndex,
      isSelected: false,
    ));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPage(
          needsEditing: true,
          selectedPageIndex: state.selectedPageIndex,
        ),
      ),
    );
  }

  void fix() {
    eventPages[state.selectedPageIndex].isFixed =
        !eventPages[state.selectedPageIndex].isFixed;
    emit(state.copyWith(
      selectedPageIndex: state.selectedPageIndex,
      isSelected: false,
    ));
    _sortPages();
  }

  void _sortPages() {
    eventPages.sort((a, b) => b.isFixed ? 1 : -1);
  }
}
