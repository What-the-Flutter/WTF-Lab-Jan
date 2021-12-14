import 'package:bloc/bloc.dart';
import 'package:chat_diary/src/data/database_config.dart';
import 'package:flutter/material.dart';

import '../../../models/event_model.dart';
import '../../../models/page_model.dart';

part 'state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit()
      : super(HomeScreenState(
          listOfPages: [],
          newPageId: 0,
        ));

  void init() async {
    final list = await databaseProvider.retrievePages();
    emit(state.copyWith(listOfPages: list, newPageId: list.length));
  }

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

  void addPage(PageModel page) async {
    state.listOfPages.add(page);
    await databaseProvider.insertPage(page);
    emit(state.copyWith(
        listOfPages: state.listOfPages, newPageId: state.newPageId + 1));
  }

  void editPage(PageModel page, PageModel oldPage) async {
    final newPage = page.copyWith(id: oldPage.id, events: oldPage.events);
    await databaseProvider.updatePage(newPage);
    final pages = await databaseProvider.retrievePages();
    emit(state.copyWith(listOfPages: pages));
  }

  void removePage(PageModel page) async {
    await databaseProvider.deletePage(page);
    final pages = await databaseProvider.retrievePages();
    emit(state.copyWith(listOfPages: pages));
  }
}
