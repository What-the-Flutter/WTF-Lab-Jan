import 'package:flutter/material.dart';
import 'app_info_settings.dart';
import 'general_settings_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
          leading: const Icon(Icons.account_tree_rounded),
          title: const Text('General'),
          trailing: const Icon(Icons.navigate_next),
          subtitle: const Text('Themes & Interface settings'),
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
          leading: const Icon(Icons.cloud),
          title: const Text('Backup & Sync'),
          trailing: const Icon(Icons.navigate_next),
          subtitle: const Text('Local & Drive backup & sync'),
          onTap: () {},
        ),
        const ListTile(
          leading: Icon(Icons.warning_amber_sharp),
          title: Text('Help'),
          trailing: Icon(Icons.navigate_next),
          subtitle: Text('Basic usage guide'),
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('App Info'),
          trailing: const Icon(Icons.navigate_next),
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
      title: const Text(
        'Settings',
      ),
    );
  }
}
