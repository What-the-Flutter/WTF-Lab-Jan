import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../settings_cubit.dart';

class GeneralSettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GeneralSettingPageState();
}

class _GeneralSettingPageState extends State<GeneralSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarFromGeneralSettingsPage(),
      body: _bodyFromGeneralSettingPage(),
    );
  }

  AppBar _appBarFromGeneralSettingsPage() {
    return AppBar(
      title: const Text(
        'General Settings',
        style: TextStyle(color: Colors.yellow),
      ),
      centerTitle: true,
      backgroundColor: Colors.black,
    );
  }

  Widget _bodyFromGeneralSettingPage() {
    return ListView(
      children: [
        Card(
          child: _settingsItem(
            title: 'Theme',
            subtitle: 'Light/Dark',
            icon: Icons.invert_colors,
            onClicked: () => context.read<SettingsCubit>().changeTheme(),
          ),
        ),
        Card(
          child: _settingsItem(
            title: 'Bubble Alignment',
            subtitle: 'force right-to-left bubble alignment',
            icon: Icons.format_align_left,
            onClicked: () => context.read<SettingsCubit>().changeBubbleAlignment(),
          ),
        ),
        Card(
          child: _settingsItem(
            title: 'Font size',
            subtitle: 'Choose app font size',
            icon: Icons.text_format,
            onClicked: () {
              showDialog(
                context: context,
                builder: (newContext) {
                  return SimpleDialog(
                    title: const Text(
                      'Font size',
                    ),
                    children: [
                      SimpleDialogOption(
                        child: const Text(
                          'Large',
                          style: TextStyle(fontSize: 30),
                        ),
                        onPressed: () {
                          context.read<SettingsCubit>().setTextTheme('large');
                          Navigator.of(context).pop();
                        },
                      ),
                      SimpleDialogOption(
                        child: const Text(
                          'Normal',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          context.read<SettingsCubit>().setTextTheme('default');
                          Navigator.of(context).pop();
                        },
                      ),
                      SimpleDialogOption(
                        child: const Text(
                          'Small',
                          style: TextStyle(fontSize: 10),
                        ),
                        onPressed: () {
                          context.read<SettingsCubit>().setTextTheme('small');
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                    backgroundColor: Colors.yellow,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _settingsItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onClicked,
  }) {
    final color = ThemeData.dark().backgroundColor;
    return ListTile(
      leading: Icon(
        icon,
        color: color,
        size: 35,
      ),
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: color),
      ),
      onTap: onClicked,
    );
  }
}
