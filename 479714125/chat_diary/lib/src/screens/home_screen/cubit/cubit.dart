import 'package:bloc/bloc.dart';

import '../../../data/database_config.dart';
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
    final listOfPages =
        await DatabaseAccess.instance.firebaseDBProvider.retrievePages();
    listOfPages.forEach(print);
    emit(state.copyWith(
        listOfPages: listOfPages, newPageId: listOfPages.length));
  }

  void migrateEventsToPage(
      PageModel page, Iterable<EventModel> eventsToMigrate) async {
    var id = page.nextEventId;
    for (var event in eventsToMigrate) {
      event.id = id;
      event.pageId = page.id;
      id += 1;
      page.nextEventId += 1;
    }

    state.listOfPages[page.id].events.insertAll(0, eventsToMigrate);
    for (var event in eventsToMigrate) {
      await DatabaseAccess.instance.firebaseDBProvider.addEvent(event);
    }

    emit(state.copyWith(listOfPages: state.listOfPages));
  }

  void addPage(PageModel page) async {
    state.listOfPages.add(page);
    await DatabaseAccess.instance.firebaseDBProvider.insertPage(page);
    emit(state.copyWith(
        listOfPages: state.listOfPages, newPageId: state.newPageId + 1));
  }

  void editPage(PageModel page, PageModel oldPage) async {
    final newPage = page.copyWith(id: oldPage.id, events: oldPage.events);
    await DatabaseAccess.instance.firebaseDBProvider.updatePage(newPage);
    emit(state.copyWith(listOfPages: []));
    final pages =
        await DatabaseAccess.instance.firebaseDBProvider.retrievePages();
    emit(state.copyWith(listOfPages: pages));
  }

  void removePage(PageModel page) async {
    await DatabaseAccess.instance.firebaseDBProvider.removePage(page.id);
    final pages =
        await DatabaseAccess.instance.firebaseDBProvider.retrievePages();
    emit(state.copyWith(listOfPages: pages));
  }
}
