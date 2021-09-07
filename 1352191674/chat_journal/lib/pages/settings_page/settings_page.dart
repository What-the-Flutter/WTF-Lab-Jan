import 'package:flutter/material.dart';

import 'general_settings/general_settigns_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings'),
      ),
      body: _listView,
    );
  }

  ListView get _listView {
    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            leading: Icon(Icons.border_all_outlined),
            trailing: Icon(Icons.navigate_next),
            title: Text('General'),
            subtitle: Text('Themes & Interface settings'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GeneralSettingsPage(),
              ),
            ),
          ),
        ],
      ).toList(),
    );
  }
}