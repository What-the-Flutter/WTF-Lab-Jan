import 'package:flutter/material.dart';
import 'package:my_chat_journal/create_new_page.dart';

import 'bottom_add_chat.dart';
import 'bottom_panel_tabs.dart';
import 'chat_pages.dart';
import 'screen_message.dart';

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
          ),
        ),
      ),
      home: StartWindow(),
      onGenerateRoute: (settings) {
        if (settings.name == ScreenMessage.routeName) {
          final PropertyPage args = settings.arguments;
          return MaterialPageRoute(builder: (context) {
            return ScreenMessage(
              title: args.title,
              messages: args.message,
            );
          });
        } else if (settings.name == CreateNewPage.routName) {
          return MaterialPageRoute(builder: (context) {
            return CreateNewPage();
          });
        } else {
          assert(false, 'Need to implement ${settings.name}');
          return null;
        }
      },
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
