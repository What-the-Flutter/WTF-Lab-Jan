import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'data/database.dart';
import 'data/shared_preferences.dart';
import 'presentation/pages/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await deleteDatabase(join(await getDatabasesPath(), 'database.db'));
  await SharedPreferencesProvider.init();
  await DatabaseProvider.init();
  runApp(const App());
}
 