import 'package:flutter/material.dart';

import 'screens/event_page.dart';
import 'screens/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'WTF Chat Journal';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: const EventScreen(),
      theme: ThemeData(
        primaryColor: Color.lerp(Colors.green, Colors.blue, 0.4),
        dialogBackgroundColor: Colors.green[100],
        selectedRowColor: Colors.green[200],
      ),
    );
  }
}
