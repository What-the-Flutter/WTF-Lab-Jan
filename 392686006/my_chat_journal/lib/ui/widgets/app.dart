import 'package:flutter/material.dart';

import 'home.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyChatJournal',
      theme: ThemeData(
        bottomNavigationBarTheme: _buildBottomNavigationBarThemeData(),
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
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
