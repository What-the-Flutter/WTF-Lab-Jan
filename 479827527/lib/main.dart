import 'package:flutter/material.dart';
import 'home_page.dart';


void main() => runApp(ChatJournal());

class ChatJournal extends StatelessWidget {
  final _appTitle = 'Chat Journal';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      home: HomePage(),
    );
  }
}


