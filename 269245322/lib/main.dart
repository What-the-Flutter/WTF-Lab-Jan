import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'database/sqlite_db_helper.dart';
import 'models/note_icon_menu_model.dart';
import 'my_app.dart';
import 'shared_preferences/sp_settings_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesProvider.initialize();
  await DBHelper.initialize();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

final Map<int, IconData> pageIcons = const {
  0: Icons.pool,
  1: Icons.sports_esports,
  2: Icons.self_improvement,
  3: Icons.whatshot,
  4: Icons.person,
  5: Icons.people,
  6: Icons.mood,
  7: Icons.school,
  8: Icons.sports,
};

final Map<int, NoteMenuItem> noteMenuItemList = const {
  0: NoteMenuItem('test', Icons.ac_unit),
  1: NoteMenuItem('test', Icons.subject),
  2: NoteMenuItem('test', Icons.not_interested),
  3: NoteMenuItem('test', Icons.ac_unit),
  4: NoteMenuItem('test', Icons.ac_unit),
  5: NoteMenuItem('test', Icons.ac_unit),
  6: NoteMenuItem('test', Icons.ac_unit),
  7: NoteMenuItem('test', Icons.ac_unit),
  8: NoteMenuItem('test', Icons.ac_unit),
  9: NoteMenuItem('test', Icons.ac_unit),
  10: NoteMenuItem('test', Icons.ac_unit),
  11: NoteMenuItem('test', Icons.ac_unit),
};
