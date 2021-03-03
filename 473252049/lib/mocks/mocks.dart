import 'package:flutter/material.dart';

import '../model/category.dart';
import '../model/record.dart';

final mockCategories = [
  Category('Notes', icon: Icons.notes),
  Category('Music', icon: Icons.music_note),
  Category('Journal', icon: Icons.note),
  Category(
    'Workout',
    icon: Icons.work_outline,
    records: [
      Record('I was in the gym. It was great'),
      Record('My legs are stronger than yesterday'),
    ],
  ),
];
