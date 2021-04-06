import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/label.dart';
import '../entity/page.dart';
import 'icon_list.dart';

class DatabaseAccess {
  static final DatabaseAccess _databaseAccess = DatabaseAccess._internal();

  static Database _db;

  factory DatabaseAccess.instance() => _databaseAccess;

  DatabaseAccess._internal();

  static void initialize() async {
    _db = await openDatabase(
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
          ' labelId INTEGER,'
          ' isFavourite INTEGER,'
          ' description TEXT,'
          ' creationTime INTEGER,'
          ' imagePath TEXT'
          ');',
        );
        db.execute(
          'CREATE TABLE labels('
          'id INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' iconIndex INTEGER,'
          ' description TEXT,'
          ' creationTime INTEGER'
          ');',
        );
        for (var i = 0; i < iconList.length; i++) {
          db.insert('labels', stockLabels[i].toMap());
        }
      },
      version: 1,
    );
  }

  Future<List<Label>> fetchLabels() async {
    final labelsMap = await _db.query('labels');

    return List<Label>.generate(
      labelsMap.length,
      (i) => Label.fromDb(
        labelsMap[i]['id'],
        labelsMap[i]['iconIndex'],
        labelsMap[i]['description'],
        DateTime.fromMillisecondsSinceEpoch(labelsMap[i]['creationTime'] * 1000),
      ),
    );
  }

  Future<List<JournalPage>> fetchPages() async {
    final pagesMap = await _db.query('pages');

    var pages = List<JournalPage>.generate(
      pagesMap.length,
      (i) => JournalPage.fromDb(
        pagesMap[i]['id'],
        pagesMap[i]['title'],
        pagesMap[i]['iconIndex'],
        pagesMap[i]['isPinned'] == 0 ? false : true,
        DateTime.fromMillisecondsSinceEpoch(pagesMap[i]['creationTime'] * 1000),
      ),
    );

    for (var i = 0; i < pagesMap.length; i++) {
      await _fetchLastEvent(pages[i]);
    }

    return pages;
  }

  void _fetchLastEvent(JournalPage page) async {
    final eventMap = await _db.rawQuery(
      'SELECT * FROM events WHERE creationTime = ( SELECT MAX ( creationTime )'
      ' FROM ( SELECT * FROM events WHERE pageId = ? ) )',
      [page.id],
    );

    if (eventMap.isNotEmpty) {
      page.lastEvent = Event.fromDb(
        eventMap.first['id'],
        eventMap.first['pageId'],
        eventMap.first['labelId'],
        eventMap.first['isFavourite'] == 0 ? false : true,
        eventMap.first['description'],
        DateTime.fromMillisecondsSinceEpoch(
            eventMap.first['creationTime'] * 1000),
        eventMap.first['imagePath'],
      );
    } else {
      page.lastEvent = null;
    }
  }

  Future<List<Event>> fetchEvents(int pageId) async {
    final eventsMap =
        await _db.rawQuery('SELECT * FROM events WHERE pageId = ?', [pageId]);
    final events = List.generate(eventsMap.length, (i) {
      return Event.fromDb(
        eventsMap[i]['id'],
        eventsMap[i]['pageId'],
        eventsMap[i]['labelId'],
        eventsMap[i]['isFavourite'] == 0 ? false : true,
        eventsMap[i]['description'],
        DateTime.fromMillisecondsSinceEpoch(
            eventsMap[i]['creationTime'] * 1000),
        eventsMap[i]['imagePath'],
      );
    });
    events.sort((a, b) => a.creationTime.compareTo(b.creationTime));
    return events;
  }

  Future<List<Event>> fetchAllEvents() async {
    final eventsMap = await _db.rawQuery('SELECT * FROM events');
    final events = List.generate(eventsMap.length, (i) {
      return Event.fromDb(
        eventsMap[i]['id'],
        eventsMap[i]['pageId'],
        eventsMap[i]['iconIndex'],
        eventsMap[i]['isFavourite'] == 0 ? false : true,
        eventsMap[i]['description'],
        DateTime.fromMillisecondsSinceEpoch(
            eventsMap[i]['creationTime'] * 1000),
        eventsMap[i]['imagePath'],
      );
    });
    events.sort((a, b) => b.creationTime.compareTo(a.creationTime));
    return events;
  }

  Future<int> insertPage(JournalPage page) async {
    return _db.insert(
      'pages',
      page.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updatePage(JournalPage page) async {
    _db.update(
      'pages',
      page.toMap(),
      where: 'id = ?',
      whereArgs: [page.id],
    );
  }

  Future<void> deletePage(JournalPage page) async {
    _db.delete(
      'pages',
      where: 'id = ?',
      whereArgs: [page.id],
    );
  }

  Future<int> insertEvent(Event event) async {
    return _db.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateEvent(Event event) async {
    _db.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<void> deleteEvent(Event event) async {
    _db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> insertLabel(Label label) async {
    return _db.insert(
      'labels',
      label.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateLabel(Label label) async {
    _db.update(
      'labels',
      label.toMap(),
      where: 'id = ?',
      whereArgs: [label.id],
    );
  }

  Future<void> deleteLabel(Label label) async {
    _db.delete(
      'labels',
      where: 'id = ?',
      whereArgs: [label.id],
    );
  }
}
