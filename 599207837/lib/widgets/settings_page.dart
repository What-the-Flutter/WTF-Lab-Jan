import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_provider/theme_cubit.dart';
import 'theme_provider/theme_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  _SettingsPageState();

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeCubit>().state;
    return Scaffold(
      backgroundColor: theme.colors.backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colors.themeColor1,
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
              (value) => setState(() {
                context.read<ThemeCubit>().changeThemeColor();
              }),
            )
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
            value: context.read<ThemeCubit>().state.tColor != ThemeColor.light,
            onChanged: (value) => onChange(value),
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            'Change Theme',
            style: TextStyle(
              color: context.read<ThemeCubit>().state.colors.textColor2,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
