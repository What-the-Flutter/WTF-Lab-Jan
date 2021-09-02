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
            'imagePath TEXT,'
            'formattedSendTime TEXT,'
            'sendTime INTEGER,'
            'isBookmarked INTEGER'
            ');');
      },
      version: 1,
    );
  }

  static Future<List<PageInfo>> fetchPages() async {
    final List<Map<String, dynamic>> maps = await database.query('pages');
    return List.generate(maps.length, (i) {
      return PageInfo(
        id: maps[i]['id'],
        iconIndex: maps[i]['iconIndex'],
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
    });
  }

  static Future<void> insertPage(PageInfo page) async {
    await database.insert(
      'pages',
      page.toMap(),
    );
  }

  static Future<void> updatePage(PageInfo page) async {
    await database.update(
      'pages',
      page.toMap(),
      where: 'id = ?',
      whereArgs: [page.id],
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
      orderBy: 'pageId',
      whereArgs: [pageId],
    );
    return List.generate(maps.length, (i) {
      return Event(
        pageId: maps[i]['pageId'],
        // categoryId: maps[i]['categoryId'],
        message: maps[i]['message'],
        imagePath: maps[i]['imagePath'],
        isBookmarked: maps[i]['isBookmarked'] == 1 ? true : false,
        formattedSendTime: maps[i]['formattedSendTime'],
        sendTime: maps[i]['sendTime'],
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
}
