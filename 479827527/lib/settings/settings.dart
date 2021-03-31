import 'package:flutter/material.dart';
import 'general_settings.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _listView,
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: Text(
        'Settings',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  ListView get _listView {
    return ListView(
      children: <Widget>[
        GestureDetector(
          child: _listTile(
            leadingIcon: Icons.account_tree,
            title: 'General',
            subtitle: 'Themes & Interface settings',
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
          child: _listTile(
            leadingIcon: Icons.cloud,
            title: 'Backup & Sync',
            subtitle: 'Local & Drive backup & sync',
          ),
          onTap: () {
            //TODO
          },
        ),
        GestureDetector(
          child: _listTile(
            leadingIcon: Icons.security,
            title: 'Security',
            subtitle: 'Pin & Fingerprint protection',
          ),
          onTap: () {
            //TODO
          },
        ),
      ],
    );
  }

  ListTile _listTile({
    IconData leadingIcon,
    String title,
    String subtitle,
  }) {
    return ListTile(
      leading: Icon(
        leadingIcon,
        size: 35,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 15,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
