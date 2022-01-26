import 'package:flutter/material.dart';

import '../../main.dart';

class SettingsPage extends StatefulWidget {
  final int _currentTheme;

  const SettingsPage(this._currentTheme, {Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState(_currentTheme);
}

class _SettingsPageState extends State<SettingsPage> {
  late ThemeInherited themeInherited;

  int currentTheme;

  _SettingsPageState(this.currentTheme);

  @override
  Widget build(BuildContext context) {
    themeInherited = ThemeInherited.of(context)!;
    return Scaffold(
      backgroundColor: themeInherited.preset.colors.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeInherited.preset.colors.themeColor1,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            _switch(
              (value) => setState(
                () {
                  themeInherited.onEdited();
                  currentTheme = value ? 1 : 0;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switch(Function(bool value) onChange) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Switch(
            activeColor: Colors.yellow.shade200,
            activeTrackColor: Colors.indigo.shade800,
            inactiveThumbColor: Colors.yellow,
            inactiveTrackColor: Colors.lightBlueAccent,
            value: currentTheme == 1,
            onChanged: (value) => onChange(value),
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            'Change Theme',
            style: TextStyle(
              color: themeInherited.preset.colors.textColor2,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
