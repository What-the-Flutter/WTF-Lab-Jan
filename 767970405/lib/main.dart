import 'package:flutter/material.dart';
import 'package:my_chat_journal/chat_pages.dart';
import 'package:my_chat_journal/bottom_panel_tabs.dart';
import 'package:my_chat_journal/bottom_add_chat.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Journal',
      theme: ThemeData(
        primaryColor: Colors.teal,
        accentColor: Colors.amberAccent,
        textTheme: TextTheme(
            subtitle1: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            bodyText2: TextStyle(
              color: Colors.black.withOpacity(0.4),
              fontSize: 16,
            )),
      ),
      home: StartWindow(),
    );
  }
}

class StartWindow extends StatefulWidget {
  @override
  _StartWindowState createState() => _StartWindowState();
}

class _StartWindowState extends State<StartWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Home')),
        actions: <Widget>[Icon(Icons.invert_colors)],
        leading: Icon(Icons.menu),
      ),
      body: ChatPages(),
      floatingActionButton: ButtonAddChat(),
      bottomNavigationBar: BottomPanelTabs(),
    );
  }
}
