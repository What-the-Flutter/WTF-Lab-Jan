import 'package:flutter/material.dart';

class JournalBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        _barItem(Icons.home_outlined,'Home'),
        _barItem(Icons.paste_outlined,'Daily'),
        _barItem(Icons.timeline_outlined,'Timeline'),
        _barItem(Icons.explore_outlined,'Explore'),
      ],
    );
  }

  BottomNavigationBarItem _barItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
