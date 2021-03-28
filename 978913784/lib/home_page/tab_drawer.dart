import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../settings_page/settings_page.dart';

class TabDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).primaryColor,
      ),
      child: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
              child: Text(
                DateFormat('MMM d, yyyy').format(DateTime.now()),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2.color,
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Theme.of(context).textTheme.bodyText1.color,
              ),
              title: Text(
                'Settings',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
