import 'package:flutter/material.dart';

import 'constants.dart';
import 'pages/home/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MaterialColor customBlueColor = MaterialColor(0xFF1E81F5, color);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Journal',
      theme: ThemeData(
        primarySwatch: customBlueColor,
      ),
      home: HomePage(),
    );
  }
}


