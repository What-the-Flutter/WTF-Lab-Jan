import 'package:flutter/material.dart';
import 'event/screens/event.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyChatJournal',
      theme: _theme(),
      home: const EventScreen(),
    );
  }

  ThemeData _theme() {
    return ThemeData(
      bottomNavigationBarTheme: _buildBottomNavigationBarThemeData(),
      primarySwatch: Colors.blue,
      primaryColor: Color.lerp(Colors.green, Colors.blue, 0.4),
      dialogBackgroundColor: Colors.green[100],
      selectedRowColor: Colors.green[300],
    );
  }

  BottomNavigationBarThemeData _buildBottomNavigationBarThemeData() {
    return const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    );
  }
}
