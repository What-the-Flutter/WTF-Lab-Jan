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
      title: 'Chat journal',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(
        title: 'Home',
      ),
    );
  }
}
