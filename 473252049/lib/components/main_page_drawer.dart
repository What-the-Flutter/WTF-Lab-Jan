import 'package:chat_journal/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MainPageDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text('Drawer Header'),
          ),
          drawerItem(Icons.card_giftcard, 'Help spread the world', () {}),
          drawerItem(Icons.search, 'Search', () {}),
          drawerItem(Icons.notifications, 'Notifications', () {}),
          drawerItem(Icons.whatshot, 'Statistics', () {}),
          drawerItem(
            Icons.settings,
            'Settings',
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
          drawerItem(Icons.feedback, 'Feedback', () {}),
        ],
      ),
    );
  }
}

Widget drawerItem(IconData icon, String text, void Function() onTap) {
  return ListTile(
    title: Text(text),
    leading: Icon(icon),
    onTap: onTap,
  );
}
