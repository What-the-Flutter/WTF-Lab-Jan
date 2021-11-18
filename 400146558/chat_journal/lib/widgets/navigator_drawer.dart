import 'package:chat_journal/widgets/settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NavigatorDrawer extends StatelessWidget {
  const NavigatorDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: const TextStyle(
                    color: Colors.white,
                  )),
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.redAccent,
              ),
              title: Text(
                'Settings',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
