import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Event {
  int id;
  int categoryId;
  String text;
  String dateTime;


  Event({required this.id,required this.categoryId, required this.text, required this.dateTime});

  Map<String, dynamic> convertEventToMap() {
    return {
      'category_id': categoryId,
      'event_text': text,
      'event_time': dateTime,
    };
  }

  Map<String, dynamic> convertEventToMapWithId() {
    return {
      'event_id': id,
      'category_id': categoryId,
      'event_text': text,
      'event_time': dateTime,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
       id: map['event_id'],
       categoryId: map['category_id'],
       text: map['event_text'],
       dateTime: map['event_time'],
    );
  }
}

class Category {
  int id;
  int iconIndex;
  String dateTime;
  String name;

  Category({required this.id, required this.name, required this.iconIndex, required this.dateTime});

  Map<String, dynamic> convertCategoryToMapWithId() {
    return {
      'id': id,
      'name': name,
      'icon_index': iconIndex,
      'category_date': dateTime,
    };
  }

  Map<String, dynamic> convertCategoryToMap() {
    return {
      'name': name,
      'icon_index': iconIndex,
      'category_date': dateTime,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      iconIndex: map['icon_index'],
      dateTime: map['category_date'],
    );
  }
}

List<Category> initialCategories = [
];
List<IconData> initialIcons = [
  Icons.family_restroom,
  Icons.work,
  Icons.local_shipping,
  Icons.sports_basketball,
  Icons.wine_bar,
  Icons.accessibility,
  Icons.agriculture,
  Icons.anchor,
  Icons.category,
  Icons.title,
  Icons.airline_seat_flat_rounded,
  Icons.attach_money,
  Icons.attach_file_outlined,
  Icons.auto_fix_high,
  Icons.workspaces_filled,
];

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.teal,
  primarySwatch: Colors.green,
  dialogBackgroundColor: Colors.tealAccent,
  focusColor: Colors.tealAccent,
  accentColor: Colors.teal,
  backgroundColor: Colors.grey,
  buttonColor: Colors.tealAccent,
  iconTheme: IconThemeData(color: Colors.teal),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    unselectedItemColor: Colors.blueGrey,
    selectedItemColor: Colors.teal,
    elevation: 2,
  ),
);
ThemeData darkTheme = ThemeData.dark();
