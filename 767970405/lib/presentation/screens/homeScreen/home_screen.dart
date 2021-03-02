import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme_model.dart';
import 'bottom_add_chat.dart';
import 'bottom_panel_tabs.dart';
import 'chat_pages.dart';

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
      floatingActionButton: ButtonAddChat(),
      bottomNavigationBar: BottomPanelTabs(),
    );
  }
}