import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/page.dart';

class DatabaseAccess {
  Database db;

  void initialize() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE pages('
              'id INTEGER PRIMARY KEY AUTOINCREMENT,'
              ' title TEXT, iconIndex INTEGER,'
              ' isPinned INTEGER,'
              ' creationTime INTEGER'
              ');',
        );
        db.execute(
          'CREATE TABLE events('
              'id INTEGER PRIMARY KEY AUTOINCREMENT,'
              ' pageId INTEGER,'
              ' iconIndex INTEGER,'
              ' isFavourite INTEGER,'
              ' description TEXT,'
              'creationTime INTEGER'
              ');',
        );
      },
      version: 1,
    );
  }

  Future<List<JournalPage>> fetchPages() async {
    final pagesMap = await db.query('pages');

    var pages = List<JournalPage>.generate(pagesMap.length, (i) {
      return JournalPage.fromDb(
        pagesMap[i]['id'],
        pagesMap[i]['title'],
        pagesMap[i]['iconIndex'],
        pagesMap[i]['isPinned'] == 0 ? false : true,
        DateTime.fromMillisecondsSinceEpoch(pagesMap[i]['creationTime'] * 1000),
      );
    });

    for (var i = 0; i < pagesMap.length; i++) {
      await _fetchLastEvent(pages[i]);
    }

    return pages;
  }

  void _fetchLastEvent(JournalPage page) async {
    final eventMap = await db.rawQuery(
      'SELECT * FROM events WHERE creationTime = ( SELECT MAX ( creationTime ) FROM ( SELECT * FROM events WHERE pageId = ? ) )',
      [page.id],
    );

    if (eventMap.isNotEmpty) {
      page.lastEvent = Event.fromDb(
        eventMap.first['id'],
        eventMap.first['pageId'],
        eventMap.first['iconIndex'],
        eventMap.first['isFavourite'] == 0 ? false : true,
        eventMap.first['description'],
        DateTime.fromMillisecondsSinceEpoch(
            eventMap.first['creationTime'] * 1000),
      );
    } else {
      page.lastEvent = null;
    }
  }

  Future<List<Event>> fetchEvents(int pageId) async {
    final eventsMap =
        await db.rawQuery('SELECT * FROM events WHERE pageId = ?', [pageId]);

    var events = List.generate(eventsMap.length, (i) {
      return Event.fromDb(
        eventsMap[i]['id'],
        eventsMap[i]['pageId'],
        eventsMap[i]['iconIndex'],
        eventsMap[i]['isFavourite'] == 0 ? false : true,
        eventsMap[i]['description'],
        DateTime.fromMillisecondsSinceEpoch(
            eventsMap[i]['creationTime'] * 1000),
      );
    });

    events.sort((a, b) => a.creationTime.compareTo(b.creationTime));

    return events;
  }

  void insertPage(JournalPage page) async {
    await db.insert(
      'pages',
      page.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updatePage(JournalPage page) async {
    await db.update(
      'pages',
      page.toMap(),
      where: 'id = ?',
      whereArgs: [page.id],
    );
  }

  void deletePage(JournalPage page) async {
    await db.delete(
      'pages',
      where: 'id = ?',
      whereArgs: [page.id],
    );
  }

  void insertEvent(Event event) async {
    await db.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateEvent(Event event) async {
    await db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  void deleteEvent(Event event) async {
    await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }
}
