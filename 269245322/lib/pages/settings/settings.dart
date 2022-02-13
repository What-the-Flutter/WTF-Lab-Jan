import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../services/firebase_auth_service.dart';
import '../../style/theme_cubit.dart';
import 'settings_cubit.dart';
import 'settings_state.dart';

class SettingsPage extends StatefulWidget {
  late final ThemeCubit themeCubit;
  SettingsPage({Key? key, required this.themeCubit}) : super(key: key);

  static const routeName = '/pageSettings';
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsCubit _settingsCubit = SettingsCubit();
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _settingsCubit.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
        bloc: _settingsCubit,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Center(child: Text('Settings')),
            ),
            body: settingsButtons(
                _auth, _settingsCubit, state, context, widget.themeCubit),
          );
        });
  }
}

Padding settingsButtons(AuthService auth, SettingsCubit settingsCubit,
    SettingsState state, BuildContext context, ThemeCubit themeCubit) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Theme mode'),
            ToggleSwitch(
              initialLabelIndex: state.theme,
              totalSwitches: 2,
              labels: ['Light', 'Dark'],
              animate: true,
              animationDuration: 150,
              onToggle: (index) => settingsCubit.changeTheme(index, themeCubit),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Database'),
            ToggleSwitch(
              initialLabelIndex: state.database,
              totalSwitches: 2,
              labels: ['Server', 'Local'],
              animate: true,
              animationDuration: 150,
              onToggle: (index) => settingsCubit.changeDatabase(index),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Aligment'),
            ToggleSwitch(
              minWidth: 150.0,
              initialLabelIndex: state.aligment,
              totalSwitches: 2,
              labels: ['Bubble Alignment', 'Center Date Bubble'],
              animate: true,
              animationDuration: 150,
              onToggle: (index) => settingsCubit.changeAligment(index),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Text size'),
            ToggleSwitch(
              initialLabelIndex: state.textSize,
              totalSwitches: 3,
              labels: ['Small', 'Medium', 'Large'],
              animate: true,
              animationDuration: 150,
              onToggle: (index) => settingsCubit.changeTextSize(index),
            ),
          ],
        ),
        const SizedBox(
          height: 40.0,
        ),
        ElevatedButton(
          child: const Text('Reset to zavodskie'),
          onPressed: () {
            settingsCubit.resetSettings(themeCubit);
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: const Text('Sign in anon'),
          onPressed: () async {
            dynamic result = await auth.signInAnon();
            if (result == null) {
              print('error signing in');
            } else {
              print('signed in');
              print(result);
            }
          },
        ),
        ElevatedButton(
            child: const Text('Share'), onPressed: settingsCubit.share),
      ],
    ),
  );
}
