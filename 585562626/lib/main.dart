import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/category.dart';
import 'pages/home_page.dart';
import 'widgets/inherited/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RootWidget(
      child: LayoutBuilder(
        builder: (context, _) {
          return MaterialApp(
            title: 'Cool Notes',
            theme: AppTheme.of(context).theme,
            home: HomePage(
              title: 'Home',
              categories: [
                NoteCategory('Sports', Colors.orangeAccent, 'sports.png'),
                NoteCategory('Travel', Colors.lightBlue, 'travel.png'),
                NoteCategory('Family', Colors.indigoAccent, 'family.png'),
              ],
            ),
          );
        },
      ),
    );
  }
}
