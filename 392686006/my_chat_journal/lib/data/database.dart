import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../domain/entities/event.dart';
import '../domain/entities/event_element.dart';
import 'data.dart';

class DatabaseProvider {
  static late final Database database;

  DatabaseProvider._();

  static Future<void> init() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version) {
        db.execute('CREATE TABLE events('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'iconIndex INTEGER,'
            'title TEXT,'
            'lastMessage TEXT,'
            'lastEditDate TEXT,'
            'createDate TEXT,'
            'isPinned INTEGER'
            ');');
        db.execute('CREATE TABLE eventelements('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'eventId INTEGER,'
            'categoryId INTEGER,'
            'message TEXT,'
            'imagePath TEXT,'
            'stringSendTime TEXT,'
            'sendTime INTEGER,'
            'isBookmarked INTEGER'
            ');');
      },
      version: 1,
    );
  }

  static Future<List<Event>> fetchEvents() async {
    final List<Map<String, dynamic>> maps = await database.query('eventElements');
    return List.generate(maps.length, (i) {
      return Event(
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

  static Future<List<EventElement>> fetchEventElements(int eventId) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'eventelements',
      where: 'eventId = ?',
      orderBy: 'eventId',
      whereArgs: [eventId],
    );
    return List.generate(maps.length, (i) {
      return EventElement(
        eventId: maps[i]['eventId'],
        // categoryId: maps[i]['categoryId'],
        message: maps[i]['message'],
        imagePath: maps[i]['imagePath'],
        isBookmarked: maps[i]['isBookmarked'] == 1 ? true : false,
        stringSendTime: maps[i]['stringSendTime'],
        sendTime: maps[i]['sendTime'],
      );
    }).reversed.toList();
  }

  static Future<void> insertEventElement(EventElement eventElement) async {
    await database.insert(
      'eventelements',
      eventElement.toMap(),
    );
  }

  static Future<void> updateEventElement(EventElement eventElement) async {
    await database.update(
      'eventelements',
      eventElement.toMap(),
      where: 'id = ?',
      whereArgs: [eventElement.id],
    );
  }

  static Future<void> deleteEventElement(EventElement event) async {
    await database.delete(
      'eventelements',
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }
}