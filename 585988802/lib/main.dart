import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(App());
}

///Main class of app.
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      titleStyle: 'Chat journal',
      previewTheme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(
        title: 'Home',
      ),
    );
  }
}
