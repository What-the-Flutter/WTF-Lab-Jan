import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../models/event_model.dart';
import '../../models/page_model.dart';

part 'state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit()
      : super(HomeScreenState(
          listOfPages: [
            PageModel(
              icon: Icons.edit,
              name: 'Notes',
              id: 0,
              nextEventId: 0,
            ),
            PageModel(
              icon: Icons.warning,
              name: 'Important',
              id: 1,
              nextEventId: 0,
            ),
            PageModel(
              icon: Icons.spa,
              name: 'Relax',
              id: 2,
              nextEventId: 0,
            ),
          ],
          newPageId: 3,
        ));

  void _emitStateWithEditedList() {
    emit(state.copyWith(listOfPages: state.listOfPages));
  }

  void migrateEventsToPage(
      PageModel page, Iterable<EventModel> eventsToMigrate) {
    var index = state.listOfPages.indexOf(page);
    var id = page.nextEventId;
    for (var event in eventsToMigrate) {
      event.id = id;
      event.pageId = page.id;
      id += 1;
      page.nextEventId += 1;
    }
    state.listOfPages[index].events.insertAll(0, eventsToMigrate);
    _emitStateWithEditedList();
  }

  void addPage(PageModel page) {
    state.listOfPages.add(page);
    emit(state.copyWith(
        listOfPages: state.listOfPages, newPageId: state.newPageId + 1));
  }

  void editPage(PageModel page, PageModel oldPage) {
    final newPage = page.copyWith(id: oldPage.id, events: oldPage.events);

    int? index =
        state.listOfPages.indexWhere((element) => element.id == oldPage.id);

    if (index != -1) {
      state.listOfPages[index] = newPage;
    }
    _emitStateWithEditedList();
  }

  void removePageById(int id) {
    state.listOfPages.removeWhere((element) => element.id == id);
    _emitStateWithEditedList();
  }
}