import 'package:flutter/material.dart';
import 'homepage.dart';
import 'theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppTheme(
      builder: (context, _brightness) {
        return MaterialApp(
          title: 'My Homework App',
          theme: ThemeData(
            primarySwatch: Colors.red,
            brightness: _brightness,
          ),
          home: HomePage(),
        );
      },
    );
  }
}
