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
          drawerItem(Icons.settings, 'Settings', () {}),
          drawerItem(Icons.feedback, 'Feedback', () {}),
        ],
      ),
    );
  }
}

// _drawerItem(Icons.card_giftcard, 'Help spread the world', () {}),
//     _drawerItem(Icons.search, 'Search', () {}),
//     _drawerItem(Icons.notifications, 'Notifications', () {}),
//     _drawerItem(Icons.whatshot, 'Statistics', () {}),
//     _drawerItem(Icons.settings, 'Settings', () {}),
//     _drawerItem(Icons.feedback, 'Feedback', () {}),

Widget drawerItem(IconData icon, String text, void Function() onTap) {
  return ListTile(
    title: Text(text),
    leading: Icon(icon),
    onTap: onTap,
  );
}
