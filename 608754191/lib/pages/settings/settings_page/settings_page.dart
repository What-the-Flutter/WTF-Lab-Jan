import 'package:flutter/material.dart';
import '../../authorization/authorization_page.dart';

import 'general_settings/general_settings_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarFromSettingsPage(),
      body: _bodyFromSettingsPage(),
    );
  }

  AppBar _appBarFromSettingsPage() {
    return AppBar(
      title: const Text(
        'Settings',
        style: TextStyle(color: Colors.yellow),
      ),
      centerTitle: true,
      backgroundColor: Colors.black,
    );
  }

  Widget _bodyFromSettingsPage() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (
              context,
              index,
            ) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 1),
                child: Card(
                  child: _settingsItem(
                    title: 'General',
                    subtitle: 'Themes & Interfaces',
                    icon: Icons.clear,
                    onClicked: () => _selectedSetting(context, 0),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (
              context,
              index,
            ) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 5, 1),
                child: Card(
                  child: _settingsItem(
                    title: 'Authorization',
                    subtitle: 'Themes & Interfaces',
                    icon: Icons.accessibility_new,
                    onClicked: () => _selectedSetting(context, 1),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _settingsItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onClicked,
  }) {
    final color = ThemeData.dark().backgroundColor;

    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: color),
      ),
      onTap: onClicked,
    );
  }

  void _selectedSetting(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GeneralSettingPage(),
          ),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AuthorizationPage(),
          ),
        );
        break;
    }
  }
}
