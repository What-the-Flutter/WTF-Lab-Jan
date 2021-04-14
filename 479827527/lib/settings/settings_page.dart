import 'package:flutter/material.dart';
import 'application_info_page.dart';
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
      body: _listView,
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: Text(
        'Settings',
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
        GestureDetector(
          child: _listTile(
            leadingIcon: Icons.info,
            title: 'App info',
            subtitle: 'Feedback & Specifications',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApplicationInfo(),
              ),
            );
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
      ),
      subtitle: Text(
        subtitle,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 15,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
