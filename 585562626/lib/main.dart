import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/category.dart';
import 'pages/home_page.dart';
import 'utils/themes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cool Notes',
      darkTheme: darkTheme,
      theme: lightTheme,
      home: HomePage(
        title: 'Home',
        categories: [
          NoteCategory('Sports', Colors.orangeAccent, 'sports.png'),
          NoteCategory('Travel', Colors.lightBlue, 'travel.png'),
          NoteCategory('Family', Colors.indigoAccent, 'family.png'),
        ],
      ),
    );
  }
}
