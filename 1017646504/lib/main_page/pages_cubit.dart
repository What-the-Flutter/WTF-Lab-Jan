import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../page.dart';

class PagesCubit extends Cubit<List<JournalPage>> {
  late final Database database;

  PagesCubit(List<JournalPage> state) : super(state);

  Future<void> _initDb() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE events(id INTEGER PRIMARY KEY, pageId INTEGER, iconIndex INTEGER, isFavourite INTEGER, description TEXT,creationTime TEXT)',
        );
        db.execute(
          'CREATE TABLE pages(id INTEGER PRIMARY KEY, title TEXT, iconIndex INTEGER, isPinned INTEGER, creationTime TEXT)',
        );
      },
      version: 1,
    );
  }

  void init() async {
    await _initDb();
    // _initPagesDb();
    List<Map<String, dynamic>> pagesMap = await database.query('pages');

    final pages = List<JournalPage>.generate(
      pagesMap.length,
      (i) {
        return JournalPage.fromDb(
          pagesMap[i]['id'],
          pagesMap[i]['title'],
          pagesMap[i]['iconIndex'],
          pagesMap[i]['isPinned'] == 0 ? false : true,
          DateTime.parse(pagesMap[i]['creationTime']),
        );
      },
    );

    List<Map<String, dynamic>> eventsMap = await database.query('events');

    final events = List.generate(
      eventsMap.length,
      (i) {
        return Event.fromDb(
          eventsMap[i]['id'],
          eventsMap[i]['pageId'],
          eventsMap[i]['iconIndex'],
          eventsMap[i]['isFavourite'] == 0 ? false : true,
          eventsMap[i]['description'],
          DateTime.parse(eventsMap[i]['creationTime']),
        );
      },
    );

    events.sort((a, b) => a.creationTime.compareTo(b.creationTime));

    for (final event in events) {
      pages.where((page) => page.id == event.pageId).toList()[0].addEvent(event);
    }

    emit(sortList(pages));
  }

  void addPage(JournalPage page) async {
    final updatedPages = List<JournalPage>.from(state..add(page));
    await database.insert(
      'pages',
      page.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    emit(sortList(updatedPages));
  }

  void pinPage(JournalPage page) async {
    final updatedPages = List<JournalPage>.from(state..remove(page));
    page.isPinned = !page.isPinned;
    await database.update(
      'pages',
      page.toMap(),
      where: 'id = ?',
      whereArgs: [page.id],
    );
    if (page.isPinned) {
      updatedPages.insert(0, page);
    } else {
      updatedPages.add(page);
    }
    sortList(updatedPages);
    emit(updatedPages);
  }

  void editPage(JournalPage page, JournalPage editedPage) async {
    page.title = editedPage.title;
    page.iconIndex = editedPage.iconIndex;
    await database.update(
      'pages',
      page.toMap(),
      where: 'id = ?',
      whereArgs: [page.id],
    );
    final updatedPages = List<JournalPage>.from(state);
    emit(updatedPages);
  }

  void deletePage(JournalPage page) async {
    final updatedPages = List<JournalPage>.from(state..remove(page));
    await database.delete(
      'pages',
      where: 'id = ?',
      whereArgs: [page.id],
    );
    emit(updatedPages);
  }

  void updatePages() {
    final updatedPages = List<JournalPage>.from(state);
    emit(sortList(updatedPages));
  }

  void acceptForward(JournalPage page, Set<Event> forwarded) {
    List forwardedList = forwarded.toList()
      ..sort((a, b) => a.creationTime.compareTo(b.creationTime));
    for (var forwardedEvent in forwardedList) {
      page.addEvent(forwardedEvent);
    }
    final updatedPages = List<JournalPage>.from(state);
    emit(sortList(updatedPages));
  }

  List<JournalPage> sortList(List<JournalPage> list) {
    final pinned = list.where((element) => element.isPinned).toList();
    final unpinned = list.where((element) => !element.isPinned).toList();

    unpinned.sort(
      (a, b) {
        final firstEvent = b.lastEvent;
        final secondEvent = a.lastEvent;
        if (firstEvent != null && secondEvent != null) {
          return firstEvent.creationTime.compareTo(secondEvent.creationTime);
        } else if (firstEvent == null && secondEvent == null) {
          return 0;
        } else if (secondEvent == null) {
          return 1;
        } else {
          return -1;
        }
      },
    );

    return [
      ...pinned,
      ...unpinned,
    ];
  }
}
