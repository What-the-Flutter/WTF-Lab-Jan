import 'package:flutter/material.dart';

import '../model/category.dart';
import '../model/record.dart';

List<Category> mockCategories = [
  Category.withRecords('Music', Icons.music_note, [
    Record('ABC'),
    Record('DEF'),
    Record("It's music category!"),
  ]),
  Category('Workout', Icons.accessibility_new),
  Category('Notes', Icons.menu_book_outlined),
  Category('Journal', Icons.book),
];
