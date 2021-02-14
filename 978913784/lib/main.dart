import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppTheme(
      key: AppThemeData.appThemeStateKey,
      child: MaterialApp(
        title: 'Chat Journal',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: HomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
