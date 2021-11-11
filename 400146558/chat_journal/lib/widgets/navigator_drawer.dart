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
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Text(DateFormat.yMMMMd().format(DateTime.now())),
          ),
          ListTile(
            leading: const Icon(
              Icons.card_giftcard,
            ),
            title: Text(
              'Help spread the word',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
