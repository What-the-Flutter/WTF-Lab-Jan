import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class Category {
  final int? id;
  final String title;
  final IconData icon;

  Category({
    required this.id,
    required this.title,
    required this.icon,
  });
}

final travel = Category(id: 0, title: 'Travel', icon: LineIcons.planeDeparture);
final sport = Category(id: 2, title: 'Sport', icon: LineIcons.running);
final work = Category(id: 2, title: 'Work', icon: LineIcons.briefcase);
final home = Category(id: 2, title: 'Home', icon: LineIcons.home);

final categoryList = [travel, sport, home, work];
