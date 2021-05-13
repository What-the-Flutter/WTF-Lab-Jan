import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens/home_screen/home_page.dart';

void main() => runApp(AppTracker());

class AppTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events',
      home: HomePage(),
    );
  }
}
