import 'package:flutter/material.dart';

import 'themes/theme.dart';
import 'themes/themes_model.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeChanger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        elevation: 0,
        actions: [],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dark Theme',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Switch(
              value: theme.isDark(),
              onChanged: (value) {
                print(value);
                if (value) {
                  theme.switchTheme(Themes.dark);
                } else {
                  theme.switchTheme(Themes.light);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
