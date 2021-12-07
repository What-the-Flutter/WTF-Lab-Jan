import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../models/event_model.dart';
import '../../models/page_model.dart';

part 'state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit()
      : super(HomeScreenState(listOfPages: [
          PageModel(icon: Icons.edit, name: 'Notes'),
          PageModel(icon: Icons.warning, name: 'Important'),
          PageModel(icon: Icons.spa, name: 'Relax'),
        ]));

  void _emitStateWithEditedList() {
    emit(state.copyWith(listOfPages: state.listOfPages));
  }

  void migrateEventsToPage(
      PageModel page, Iterable<EventModel> eventsToMigrate) {
    var index = state.listOfPages.indexOf(page);
    state.listOfPages[index].events.addAll(eventsToMigrate);
    _emitStateWithEditedList();
  }

  void addPage(PageModel page) {
    state.listOfPages.add(page);
    _emitStateWithEditedList();
  }

  void editPage(PageModel page, PageModel oldPage) {
    final newPage = page.copyWith(key: oldPage.key, events: oldPage.events);

    int? index =
        state.listOfPages.indexWhere((element) => element.key == oldPage.key);

    if (index != -1) {
      state.listOfPages[index] = newPage;
    }
    _emitStateWithEditedList();
  }

  void removePageByKey(Key key) {
    state.listOfPages.removeWhere((element) => element.key == key);
    _emitStateWithEditedList();
  }
}