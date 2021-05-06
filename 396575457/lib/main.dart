import 'package:diary_in_chat_format_app/screens/home_screen/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(AppTracker());

class AppTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Events',
        home: DefaultTabController(
          length: 1,
          child: HomePage(),
        ));
  }
}

