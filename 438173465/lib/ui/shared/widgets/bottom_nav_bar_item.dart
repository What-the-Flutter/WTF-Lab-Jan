import 'package:flutter/material.dart';

BottomNavigationBarItem bottomNavBarItem({
  IconData icon,
  String label,
  Function function,
}) {
  return BottomNavigationBarItem(
    label: label,
    icon: Icon(
      icon,
    ),
  );
}
