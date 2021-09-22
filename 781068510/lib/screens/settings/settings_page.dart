import 'package:flutter/material.dart';

import 'general_settings_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const double iconSize = 25.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _listView,
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: const Text(
        'Settings',
      ),
    );
  }

  ListView get _listView {
    return ListView(
      padding: const EdgeInsets.only(top: 10),
      children: <Widget>[
        GestureDetector(
          child: const ListTile(
            leading: Icon(Icons.color_lens, size: iconSize),
            title: Text('General'),
            subtitle: Text('Themes & Interface settings'),
            trailing: Icon(Icons.keyboard_arrow_right_rounded),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GeneralSettings(),
              ),
            );
          },
        ),
        GestureDetector(
          child: const ListTile(
            leading: Icon(Icons.cloud, size: iconSize),
            title: Text('Backup & Sync'),
            subtitle: Text('Local & Drive backup & sync'),
            trailing: Icon(Icons.keyboard_arrow_right_rounded),
          ),
          onTap: () {
            //TODO
          },
        ),
        GestureDetector(
          child: const ListTile(
            leading: Icon(Icons.archive, size: iconSize),
            title: Text('Exports'),
            subtitle: Text('Textual backup of all your entries'),
            trailing: Icon(Icons.keyboard_arrow_right_rounded),
          ),
          onTap: () {
            //TODO
          },
        ),
        GestureDetector(
          child: const ListTile(
            leading: Icon(Icons.lock, size: iconSize),
            title: Text('Security'),
            subtitle: Text('Pin & Fingerprint protection'),
            trailing: Icon(Icons.keyboard_arrow_right_rounded),
          ),
          onTap: () {
            //TODO
          },
        ),
        GestureDetector(
          child: const ListTile(
            leading: Icon(Icons.quickreply, size: iconSize),
            title: Text('Quick Setup'),
            subtitle: Text('Create pre-defined pages quickly'),
            trailing: Icon(Icons.keyboard_arrow_right_rounded),
          ),
          onTap: () {},
        ),
        GestureDetector(
          child: const ListTile(
            leading: Icon(Icons.help, size: iconSize),
            title: Text('Help'),
            subtitle: Text('Basic usage guide'),
            trailing: Icon(Icons.keyboard_arrow_right_rounded),
          ),
          onTap: () {},
        ),
        GestureDetector(
          child: const ListTile(
            leading: Icon(Icons.info, size: iconSize),
            title: Text('App info'),
            subtitle: Text('Feedback & Specifications'),
            trailing: Icon(Icons.keyboard_arrow_right_rounded),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
