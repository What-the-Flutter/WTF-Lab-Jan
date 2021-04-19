import 'package:flutter/material.dart';
import 'app_info_settings.dart';
import 'general_settings_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _bodyListView,
    );
  }

  ListView get _bodyListView {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.account_tree_rounded),
          title: Text('General'),
          trailing: Icon(Icons.navigate_next),
          subtitle: Text('Themes & Interface settings'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GeneralSettingsPage(),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.cloud),
          title: Text('Backup & Sync'),
          trailing: Icon(Icons.navigate_next),
          subtitle: Text('Local & Drive backup & sync'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.warning_amber_sharp),
          title: Text('Help'),
          trailing: Icon(Icons.navigate_next),
          subtitle: Text('Basic usage guide'),
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text('App Info'),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppInfoSettings(),
              ),
            );
          },
        ),
      ],
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: Text(
        'Settings',
      ),
    );
  }
}
