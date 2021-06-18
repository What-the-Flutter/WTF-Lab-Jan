import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Event {
  String text;
  DateTime dateTime;

  Event(this.text, this.dateTime);
}

class Category {
  final String name;
  List<Event> events;
  final IconData iconData;

  Category(this.name, this.events, this.iconData);
}

List<Category> initialCategories = [
  Category('Family', [], Icons.family_restroom),
  Category('Job', [], Icons.work),
  Category('Travel', [], Icons.local_shipping),
  Category('Sports', [], Icons.sports_basketball),
  Category('Friends', [], Icons.wine_bar),
];
List<IconData> initialIcons = [
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
    )),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: Colors.blueGrey,
      selectedItemColor: Colors.teal,
      elevation: 2,
    ));
ThemeData darkTheme = ThemeData.dark();
