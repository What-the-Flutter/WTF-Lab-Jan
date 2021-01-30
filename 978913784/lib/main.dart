import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Journal',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
