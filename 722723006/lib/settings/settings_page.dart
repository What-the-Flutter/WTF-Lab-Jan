import 'package:flutter/material.dart';
import 'app_info_settings/app_info_settings.dart';
import 'general_settings/general_settings_page.dart';

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
        title: Text(
          'Settings',
        ),
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
            trailing: Icon(Icons.navigate_next),
            title: Text('Backup & Sync'),
            subtitle: Text('Local & Drive backup & sync'),
          ),
          ListTile(
            leading: Icon(Icons.info),
            trailing: Icon(Icons.navigate_next),
            title: Text('App info'),
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
      ).toList(),
    );
  }
}
