import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NavigatorDrawer extends StatelessWidget {
  const NavigatorDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(DateFormat.yMMMMd().format(DateTime.now())),
          ),
          ListTile(
            leading: const Icon(
              Icons.card_giftcard,
            ),
            title: const Text('Help spread the word'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
