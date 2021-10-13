import 'package:flutter/material.dart';

class Config {
  static List<BottomNavigationBarItem> navigationBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.assignment),
      label: 'Daily',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.timeline),
      label: 'Timeline',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.explore),
      label: 'Explore',
    ),
  ];

  static BottomNavigationBar navigationBar = BottomNavigationBar(
    items: navigationBarItems,
    type: BottomNavigationBarType.fixed,
    fixedColor: Colors.green,
  );
}
