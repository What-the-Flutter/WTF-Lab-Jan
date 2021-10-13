import 'package:flutter/material.dart';

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
                    child: _buildSettingsItem(
                      title: 'General',
                      subtitle: 'Themes & Interfaces',
                      icon: Icons.clear,
                      onClicked: () => _selectedSetting(context, 0),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onClicked,
  }) {
    final color = Colors.black;

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
    }
  }
}
