import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'database/sqlite_repository.dart';
import 'models/note_icon_menu_model.dart';
import 'my_app.dart';
import 'shared_preferences/sp_settings_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await SharedPreferencesProvider.initialize();
  } on Exception catch (e) {
    print(e.toString());
  }

  try {
    await SqliteDataBaseOpenHelper.initialize();
  } on Exception catch (e) {
    print(e.toString());
  }

  try {
    await Firebase.initializeApp();
  } on FirebaseException catch (e) {
    print(e.toString());
  }

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
  3: NoteMenuItem('test', Icons.set_meal),
  4: NoteMenuItem('test', Icons.search),
  5: NoteMenuItem('test', Icons.qr_code_scanner),
  6: NoteMenuItem('test', Icons.face),
  7: NoteMenuItem('test', Icons.g_mobiledata),
  8: NoteMenuItem('test', Icons.gavel),
  9: NoteMenuItem('test', Icons.media_bluetooth_off),
  10: NoteMenuItem('test', Icons.wallet_giftcard),
  11: NoteMenuItem('test', Icons.qr_code),
};
