import 'package:flutter/material.dart';
import 'package:my_chat_journal/theme.dart';
import 'package:provider/provider.dart';
import 'bottom_add_chat.dart';

import 'bottom_panel_tabs.dart';
import 'chat_pages.dart';
import 'create_new_page.dart';
import 'event_page.dart';
import 'screen_message.dart';
import 'theme_model.dart';

void main() {
  runApp(ChangeNotifierProvider<ThemeModel>(
      create: (context) => ThemeModel(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Journal',
      theme: Provider.of<ThemeModel>(context).currentTheme,
      home: StartWindow(),
      onGenerateRoute: (settings) {
        if (settings.name == ScreenMessage.routeName) {
          final PropertyPage args = settings.arguments;
          return MaterialPageRoute(builder: (context) {
            return ScreenMessage(args);
          });
        } else if (settings.name == CreateNewPage.routName) {
          return MaterialPageRoute(builder: (context) {
            final PropertyPage args = settings.arguments;
            if (args == null) {
              return CreateNewPage();
            } else {
              return CreateNewPage(args);
            }
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.invert_colors),
            onPressed: () {
              Provider.of<ThemeModel>(context, listen: false).toggleTheme();
            },
          ),
        ],
        leading: Icon(Icons.menu),
      ),
      body: ChatPages(),
      floatingActionButton: ButtonAddChat(_addPage),
      bottomNavigationBar: BottomPanelTabs(),
    );
  }

  void _addPage(PropertyPage result) {
    if (result.title.isNotEmpty) {
      setState(() {
        ChatPages.pages.add(result);
      });
    }
  }
}
