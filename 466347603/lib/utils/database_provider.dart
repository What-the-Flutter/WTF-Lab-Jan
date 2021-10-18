import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../modules/page_info.dart';
import 'data.dart';

class DatabaseProvider {
  static late final Database database;

  DatabaseProvider._();

  static Future<void> init() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'chat_database.db'),
      onCreate: (db, version) {
        db.execute('CREATE TABLE pages('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'iconIndex INTEGER,'
            'title TEXT,'
            'lastMessage TEXT,'
            'lastEditDate TEXT,'
            'createDate TEXT,'
            'isPinned INTEGER'
            ');');
        db.execute('CREATE TABLE events('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'pageId INTEGER,'
            'categoryId INTEGER,'
            'message TEXT,'
            'imageString TEXT,'
            'sendTime TEXT,'
            'isBookmarked INTEGER,'
            'isEdited INTEGER'
            ');');
      },
      version: 1,
    );
    if ((await fetchPages()).isEmpty) {
      initPages.forEach(insertPage);
    }
  }

  static Future<List<PageInfo>> fetchPages() async {
    final List<Map<String, dynamic>> maps = await database.query('pages');
    var pages = List<PageInfo>.generate(
      maps.length,
      (i) {
        return PageInfo(
          id: maps[i]['id'],
          icon: Icon(
            defaultIcons[maps[i]['iconIndex']],
            color: Colors.white,
          ),
          title: maps[i]['title'],
          lastMessage: maps[i]['lastMessage'],
          lastEditDate: maps[i]['lastEditDate'],
          createDate: maps[i]['createDate'],
          isPinned: maps[i]['isPinned'] == 1 ? true : false,
        );
      },
    );

    for (var i = 0; i < pages.length; i += 1) {
      pages[i].lastMessage = await getPageLastEvent(pages[i].id!);
    }
    return pages;
  }

  static Future<void> insertPage(PageInfo page) async {
    await database.insert(
      'pages',
      page.toMap(),
    );
  }

  static Future<void> updatePage(PageInfo page, [int? id]) async {
    await database.update(
      'pages',
      page.toMap(),
      where: 'id = ?',
      whereArgs: [id ?? page.id],
    );
  }

  static Future<void> deletePage(PageInfo page) async {
    await database.delete(
      'pages',
      where: 'id = ?',
      whereArgs: [page.id],
    );
  }

  static Future<List<Event>> fetchEvents(int pageId) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'events',
      where: 'pageId = ?',
      whereArgs: [pageId],
      orderBy: 'sendTime',
    );
    return List.generate(maps.length, (i) {
      return Event(
        id: maps[i]['id'],
        pageId: maps[i]['pageId'],
        categoryId: maps[i]['categoryId'],
        message: maps[i]['message'],
        imageString: maps[i]['imageString'],
        isBookmarked: maps[i]['isBookmarked'] == 1 ? true : false,
        isEdited: maps[i]['isEdited'] == 1 ? true : false,
        sendTime: DateTime.parse(maps[i]['sendTime']),
      );
    }).reversed.toList();
  }

  static Future<void> insertEvent(Event event) async {
    await database.insert(
      'events',
      event.toMap(),
    );
  }

  static Future<void> updateEvent(Event event) async {
    await database.update(
      'events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  static Future<void> deleteEvent(Event event) async {
    await database.delete(
      'events',
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  static Future<String> getPageLastEvent(int pageId) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'events',
      where: 'pageId = ?',
      whereArgs: [pageId],
      orderBy: 'sendTime',
    );
    if (maps.isNotEmpty) {
      final String message = maps.last['message'];
      final String imageString = maps.last['imageString'];
      return message != ''
          ? message.length > 35
              ? '${message.substring(0, 35)}..'
              : message
          : imageString != ''
              ? 'Image Event'
              : 'No Events. Click to create one.';
    } else {
      return 'No Events. Click to create one.';
    }
  }
}
