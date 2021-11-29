import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../models/page_model.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit() : super(HomeScreenState(listOfPages: []));

  void _emitStateWithEditedList() {
    emit(state.copyWith(listOfPages: state.listOfPages));
  }

  void addPage(PageModel page) {
    state.listOfPages.add(page);
    _emitStateWithEditedList();
  }

  void editPage(PageModel page, PageModel oldPage) {
    page.key = oldPage.key;
    page.events = oldPage.events;

    int? index =
        state.listOfPages.indexWhere((element) => element.key == oldPage.key);

    if (index != -1) {
      state.listOfPages[index] = page;
    }
    _emitStateWithEditedList();
  }

  void removePageByKey(Key key) {
    state.listOfPages.removeWhere((element) => element.key == key);
    _emitStateWithEditedList();
  }
}
