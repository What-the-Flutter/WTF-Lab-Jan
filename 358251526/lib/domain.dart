import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Event {
  String text;
  DateTime dateTime;

  Event(this.text, this.dateTime);
}

class Category {
  DateTime dateTime;
  String name;
  List<Event> events;
  IconData iconData;

  Category(this.name, this.events, this.iconData, this.dateTime);
}

List<Category> initialCategories = [
  Category('Family', [], Icons.family_restroom, DateTime.now()),
  Category('Job', [], Icons.work,DateTime.now()),
  Category('Travel', [], Icons.local_shipping,DateTime.now()),
  Category('Sports', [], Icons.sports_basketball,DateTime.now()),
  Category('Friends', [], Icons.wine_bar,DateTime.now()),
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
