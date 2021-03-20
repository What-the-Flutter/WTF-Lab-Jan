import 'package:flutter/material.dart';

import 'general_settings_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('General'),
            subtitle: Text('Themes & Interface settings'),
            leading: Icon(Icons.design_services_outlined),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return GeneralSettingPage();
                  },
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: 1,
      ),
    );
  }
}
